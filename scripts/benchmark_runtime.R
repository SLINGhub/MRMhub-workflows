#!/usr/bin/env Rscript
# ---------------------------------------------------------------------------
# benchmark_runtime.R — measure MRMhub-QUANT runtime + peak memory locally
#
# Produces the measured numbers shown in panel e of ManuscriptFigure.qmd:
#   * "Quantitation and QC" = data import + the QUANT compute pipeline
#     (normalize -> quantify -> interference/isotope corr -> drift/batch -> QC -> filter)
#   * "Reporting"           = dataset/QC-metrics export + the per-feature run-scatter
#     and response-curve QC report PDFs (the dominant reporting cost)
#   * "Max. memory footprint" = peak R heap (gc high-water mark) over the whole run
#
# Writes output/timing_dataset1.rds (SPERFECT) and output/timing_dataset3.rds (DYNAMO).
# Needs the Zenodo data present under data/dataset-1 and data/dataset-3.
#
# Usage:
#   Rscript scripts/benchmark_runtime.R          # both datasets
#   Rscript scripts/benchmark_runtime.R 1        # SPERFECT only
#   Rscript scripts/benchmark_runtime.R 3        # DYNAMO only
#
# Notes on parallelism: run-scatter PDF generation is multithreaded across the
# mirai daemons (all-but-one core). Drift correction and response-curve plotting
# are single-threaded in {mrmhub} (no parallel arg), so those times are serial.
# ---------------------------------------------------------------------------
suppressMessages({library(dplyr); library(mrmhub); library(mirai)})

n_cores <- { n <- parallel::detectCores(); if (is.na(n)) n <- 4L; max(1L, n - 1L) }
if (mirai::status()$daemons == 0) mirai::daemons(n_cores)
dir.create("output", showWarnings = FALSE)

benchmark_dataset <- function(ds) {
  acc <- new.env(); acc$import <- 0; acc$quant <- 0; acc$report <- 0
  timed <- function(key, expr) { t <- system.time(res <- force(expr))[["elapsed"]]
    acc[[key]] <- acc[[key]] + t; res }
  invisible(gc(reset = TRUE))                     # reset the peak-memory high-water mark

  if (ds == "1") {
    dp <- "./data/dataset-1/Dataset1_MRMhub-INTEGRATOR_Final.csv"
    mp <- "./data/dataset-1/Dataset1_Metadata.xlsx"
    mexp <- MRMhubExperiment()
    mexp <- timed("import", import_data_mrmhub(mexp, dp))
    mexp <- timed("import", import_metadata_msorganiser(mexp, mp, ignore_warnings = TRUE))
    mexp <- timed("quant", exclude_analyses(mexp, analyses = "Longit_batch6_51", clear_existing = TRUE))
    mexp <- timed("quant", normalize_by_istd(mexp))
    mexp <- timed("quant", quantify_by_istd(mexp))
    mexp <- timed("quant", correct_drift_gaussiankernel(mexp, variable = "conc", ref_qc_types = "SPL",
              batch_wise = TRUE, kernel_size = 20, outlier_filter = TRUE, outlier_ksd = 3,
              recalc_trend_after = TRUE, show_progress = FALSE))
    mexp <- timed("quant", correct_batch_centering(mexp, ref_qc_types = "SPL", variable = "conc"))
    mexp <- timed("quant", calc_qc_metrics(mexp, use_robust_cv = FALSE, use_batch_medians = TRUE))
    mexp <- timed("quant", filter_features_qc(data = mexp, recalc_metrics = TRUE, clear_existing = TRUE,
              use_batch_medians = TRUE, include_qualifier = FALSE, include_istd = FALSE,
              response.curves.selection = c(1, 2), response.curves.summary = "mean",
              min.rsquare.response = 0.8, min.slope.response = 0.5, max.yintercept.response = 0.5,
              min.signalblank.median.spl.pblk = 10, min.intensity.median.spl = 100,
              max.cv.conc.bqc = 25, max.dratio.sd.conc.bqc = 0.75, max.prop.missing.conc.spl = 100,
              features.to.keep = c("CE 20:4","CE 22:5","CE 22:6","CE 16:0","CE 18:0")))
    prefix <- "output/_bench_ds1"; out <- "output/timing_dataset1.rds"; label <- "SPERFECT"
  } else {
    dp <- "./data/dataset-3/Dataset3_MRMhub-INTEGRATOR_20251010.csv"
    mp <- "./data/dataset-3/Dataset3_Metadata_20251010.xlsx"
    mexp <- MRMhubExperiment()
    mexp <- timed("import", import_data_mrmhub(mexp, dp, import_metadata = TRUE))
    mexp <- timed("import", import_metadata_msorganiser(mexp, mp, ignore_warnings = TRUE))
    mexp <- timed("quant", exclude_features(mexp, features = "PC(O-36:1)", clear_existing = TRUE))
    mexp <- timed("quant", data_sum_features(mexp, feature_classes = c("LPC","LPE","LPG","LPI","LPS","DG")))
    mexp <- timed("quant", correct_interferences(mexp))
    mexp <- timed("quant", normalize_by_istd(mexp, ignore_missing_annotation = FALSE))
    mexp <- timed("quant", quantify_by_istd(mexp))
    ids_reruns <- mexp@annot_analyses |> filter(batch_id %in% c("P-43","P-42")) |> pull(analysis_id)
    mexp@dataset <- mexp@dataset |> filter(!analysis_id %in% ids_reruns)
    mexp@annot_analyses <- mexp@annot_analyses |> filter(!analysis_id %in% ids_reruns)
    mexp@annot_responsecurves <- mexp@annot_responsecurves |> filter(!analysis_id %in% ids_reruns)
    mexp <- timed("quant", correct_drift_gaussiankernel(mexp, variable = "conc", ref_qc_types = "SPL",
              batch_wise = TRUE, kernel_size = 10, outlier_filter = TRUE, outlier_ksd = 5,
              recalc_trend_after = TRUE, show_progress = FALSE))
    mexp <- timed("quant", correct_batch_centering(mexp, ref_qc_types = "SPL", variable = "conc"))
    mexp <- timed("quant", calc_qc_metrics(mexp, use_robust_cv = FALSE, use_batch_medians = TRUE,
              include_response_stats = TRUE))
    mexp <- timed("quant", filter_features_qc(data = mexp, clear_existing = TRUE, use_batch_medians = TRUE,
              include_qualifier = FALSE, include_istd = FALSE, response.curves.selection = 1,
              response.curves.summary = "mean", min.rsquare.response = 0.8, min.slope.response = 0.5,
              max.yintercept.response = 0.5, min.signalblank.median.spl.pblk = 10,
              min.intensity.median.spl = 100, max.cv.conc.bqc = 25, max.prop.missing.conc.spl = 100,
              features.to.keep = c("CE 20:4","CE 22:5","CE 22:6","CE 16:0","CE 18:0")))
    prefix <- "output/_bench_ds3"; out <- "output/timing_dataset3.rds"; label <- "DYNAMO"
  }

  # Reporting: dataset + QC-metrics export, then the per-feature QC report PDFs
  timed("report", save_dataset_csv(mexp, path = paste0(prefix, ".csv"), variable = "conc",
            qc_types = "SPL", include_qualifier = FALSE, filter_data = TRUE))
  try(timed("report", save_feature_qc_metrics(mexp, path = paste0(prefix, "_qc.csv"))), silent = TRUE)
  timed("report", plot_runscatter(mexp, variable = "conc", qc_types = c("SPL","BQC","TQC","LTR"),
            output_pdf = TRUE, path = paste0(prefix, "_runscatter.pdf"),
            multithreading = TRUE, show_progress = FALSE))
  try(timed("report", plot_responsecurves(mexp, variable = "intensity", output_pdf = TRUE,
            path = paste0(prefix, "_responsecurves.pdf"), show_progress = FALSE)), silent = TRUE)

  g <- gc(); peak_gb <- sum(g[, max(which(colnames(g) == "(Mb)"))]) / 1024  # last (Mb) col = max-used
  res <- list(label = label, dataset = ds,
              n_samples = length(unique(mexp@dataset$analysis_id)),
              n_features = length(unique(mexp@dataset$feature_id)),
              import_sec = acc$import, quant_qc_sec = acc$quant, reporting_sec = acc$report,
              peak_mem_gb = peak_gb, n_cores = n_cores)
  saveRDS(res, out)
  cat(sprintf("[DS%s %s] n=%d feat=%d | import=%.1fs quant_qc=%.1fs report=%.1fs peakmem=%.2fGb (cores=%d)\n",
      ds, label, res$n_samples, res$n_features, res$import_sec, res$quant_qc_sec,
      res$reporting_sec, res$peak_mem_gb, n_cores))
  invisible(res)
}

which <- commandArgs(trailingOnly = TRUE)
if (length(which) == 0) which <- c("1", "3")
for (ds in which) benchmark_dataset(ds)
