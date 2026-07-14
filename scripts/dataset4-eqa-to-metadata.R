#!/usr/bin/env Rscript
# ---------------------------------------------------------------------------
# dataset4-eqa-to-metadata.R
#
# Register the SKML external-quality-assessment (EQA) target concentrations
# into the canonical msorganiser metadata workbook for Dataset 4, so they are
# imported with the rest of the metadata and consumed through mrmhub's QC
# machinery (`get_qc_bias_variability()`), removing the separate-file
# dependency from `Dataset4.qmd`.
#
# What it does (idempotent — safe to re-run):
#   0. Back up the original workbook once to _archive/ (gitignored); always
#      operate FROM the backup so re-runs are deterministic (no double-append).
#   1. Fill `Sample_Id` on the 9 SPL (SKML) rows of "Analyses (Samples)",
#      grouping the `…b` replicates onto the same base Sample_Id.
#   2. Append EQA target rows to "QC Concentrations": 5 EQA samples that have a
#      target column × 13 analytes common to this panel = 65 rows. All rows are
#      `nmol/L`; DHEAS (reported in µmol/L in the EQA source) is scaled ×1000 so
#      the unit column stays uniform (calc_calibration_results requires this).
#
# Inputs  : _archive/dataset-4/Dataset4_Metadata_orig.xlsx (pristine)
#           data/dataset-4/Dataset4_SKML-EQA-expected-conc.xlsx (Sheet2)
# Output  : data/dataset-4/Dataset4_Metadata.xlsx (edited)
#
# Sheets other than "Analyses (Samples)" and "QC Concentrations" (About/Lists/
# Instructions/Features/ISTD/Response Curves/Sheet1) are preserved untouched so
# `import_metadata_msorganiser` still validates (About version 0.2.3).
# ---------------------------------------------------------------------------

suppressMessages({
  if (!requireNamespace("openxlsx2", quietly = TRUE)) {
    stop("openxlsx2 is required (fallback to openxlsx not implemented).")
  }
  library(openxlsx2)
  library(readxl)
})

# --- Paths -----------------------------------------------------------------
live_wb  <- "data/dataset-4/Dataset4_Metadata.xlsx"
backup   <- "_archive/dataset-4/Dataset4_Metadata_orig.xlsx"
eqa_file <- "data/dataset-4/Dataset4_SKML-EQA-expected-conc.xlsx"

stopifnot(file.exists(live_wb), file.exists(eqa_file))

# --- Step 0: back up the original once, then always work from the backup ----
if (!file.exists(backup)) {
  dir.create(dirname(backup), recursive = TRUE, showWarnings = FALSE)
  ok <- file.copy(live_wb, backup, overwrite = FALSE)
  if (!ok) stop("Failed to create backup at ", backup)
  message("[step 0] Backup created: ", backup)
} else {
  message("[step 0] Backup already exists (reused as pristine source): ", backup)
}

wb <- wb_load(backup)  # pristine source -> deterministic re-runs

# --- Read reference tables from the pristine workbook ----------------------
an <- wb_to_df(wb, sheet = "Analyses (Samples)", col_names = TRUE)
qc <- wb_to_df(wb, sheet = "QC Concentrations",  col_names = TRUE)
metadata_analytes <- unique(qc$Analyte_Id)

# --- Step 1: fill Sample_Id on the SPL (SKML) analyses ---------------------
# Base Sample_Id = Analysis_ID minus "_P1", minus a trailing lowercase "b"
# replicate marker.  e.g. SKML2026_1Bb_P1 -> SKML2026_1B ; SKML2025_6A_P1 -> SKML2025_6A
skml_idx <- which(grepl("^SKML", an$Analysis_ID))
if (length(skml_idx) == 0) stop("No SKML analyses found in 'Analyses (Samples)'.")

base_id <- sub("b$", "", sub("_P1$", "", an$Analysis_ID[skml_idx]))
sid_col <- which(colnames(an) == "Sample_Id")          # spreadsheet column index
excel_rows <- as.integer(rownames(an)[skml_idx])        # spreadsheet row numbers

for (i in seq_along(skml_idx)) {
  wb$add_data(
    sheet = "Analyses (Samples)",
    x     = base_id[i],
    dims  = wb_dims(rows = excel_rows[i], cols = sid_col),
    col_names = FALSE
  )
}
message("[step 1] Filled Sample_Id on ", length(skml_idx), " SKML analyses:")
print(data.frame(Analysis_ID = an$Analysis_ID[skml_idx], Sample_Id = base_id),
      row.names = FALSE)

# --- Step 2: build the EQA target rows for QC Concentrations ----------------
eqa <- as.data.frame(read_excel(eqa_file, sheet = "Sheet2", col_names = TRUE),
                     check.names = FALSE)
analyte_names <- eqa[[1]]                       # first column holds analyte names
sample_cols   <- colnames(eqa)[-1]              # e.g. "2026.1A" ... "2025.6B"

# EQA column -> Sample_Id : "2026.1A" -> "SKML2026_1A"
sample_ids <- paste0("SKML", gsub("\\.", "_", sample_cols))

# Only analytes shared with this panel's metadata (drops 17β-Estradiol / Estrone,
# which are absent from the metadata and not in the panel).
common <- intersect(analyte_names, metadata_analytes)
message("[step 2] ", length(common), " common analytes; dropped: ",
        paste(setdiff(analyte_names, metadata_analytes), collapse = ", "))

rows <- list()
for (ci in seq_along(sample_cols)) {
  for (analyte in common) {
    val <- eqa[[sample_cols[ci]]][match(analyte, analyte_names)]
    if (is.na(val)) next
    if (analyte == "DHEAS") val <- val * 1000     # µmol/L -> nmol/L
    rows[[length(rows) + 1]] <- data.frame(
      Sample_Id          = sample_ids[ci],
      Analyte_Id         = analyte,
      Concentration      = val,
      Concentration_Unit = "nmol/L",
      stringsAsFactors    = FALSE
    )
  }
}
new_rows <- do.call(rbind, rows)

# Append after the last used QC row; leave Include_In_Analysis (col E) blank.
append_row <- max(as.integer(rownames(qc))) + 1L
wb$add_data(
  sheet = "QC Concentrations",
  x     = new_rows,
  dims  = wb_dims(rows = append_row, cols = 1),
  col_names = FALSE
)
message("[step 2] Appended ", nrow(new_rows), " EQA rows to 'QC Concentrations' ",
        "starting at row ", append_row, " (units all nmol/L; DHEAS ×1000).")

# --- Step 4 (save): write the edited workbook to the live path -------------
wb_save(wb, live_wb, overwrite = TRUE)
message("[done] Saved edited workbook: ", live_wb)
