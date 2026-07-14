# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A **Quarto website** (not an application or library) of reproducible R workflows that demonstrate the [MRMhub](https://github.com/SLINGhub/MRMhub) targeted-lipidomics data-processing pipeline. The deliverable is the rendered HTML/PDF in `docs/`, which is published as Supplementary Materials for a manuscript and served via GitHub Pages at `slinghub.github.io/mrmhub-workflows`.

Each `.qmd` is a self-contained analysis notebook combining narrative, executable R, and outputs. There is no application code to "run" — work happens by editing notebooks and re-rendering.

## Build / render

```bash
quarto render                  # render all notebooks -> docs/ (output-dir set in _quarto.yml)
quarto render Dataset3.qmd     # render one notebook (both html + pdf by default)
quarto render Dataset3.qmd --to html   # html only (much faster; pdf needs lualatex)
quarto preview Dataset3.qmd    # live-reload preview while editing
```

- PDF output requires a **lualatex** engine (TinyTeX/TeX Live) and uses `caption-font.tex` as a header include. If lualatex is unavailable, render `--to html`.
- `docs/` is committed (it *is* the published site). Re-render and commit `docs/` when notebook content changes.

## Critical: the datasets are NOT in the repo

`data/dataset-1/` and `data/dataset-3/` are **gitignored** and must be downloaded from Zenodo (record `15370293`, the `mrmhub-workflows` record for processed data; `Dataset 1`/`Dataset 3` records for raw/integrator inputs). **A clean checkout cannot be fully rendered** — the notebooks read e.g. `./data/dataset-3/Dataset3_MRMhub-INTEGRATOR_20251010.csv` and the matching `*_Metadata_*.xlsx`. Expect render failures from missing data, not from broken code, unless the data has been fetched locally.

## The {mrmhub} R package

The processing functions come from `library(mrmhub)` — the **QUANT module** of MRMhub, a separate GitHub package, not code in this repo:

```r
remotes::install_github("SLINGhub/MRMhub", subdir = "quant")
```

When a function like `normalize_by_istd` or `plot_runscatter` is unfamiliar, it is defined in that package — consult <https://slinghub.github.io/MRMhub>, not this repo. The peak-integration stage (INTEGRATOR) referenced in the notebook prose is a separate desktop application; only the downstream QUANT/postprocessing is R code here.

## Notebook architecture (the pipeline)

Every notebook builds one central object, `MRMhubExperiment()`, bound to `mexp`, and threads it through the pipeline — each step takes `mexp` and returns an updated `mexp`. Canonical order (see `Dataset3.qmd` for the cleanest example):

1. `import_data_mrmhub(mexp, path)` — load INTEGRATOR `long.csv` results
2. `import_metadata_msorganiser(mexp, xlsx)` — load analyte/sample/ISTD/response-curve metadata from the `.xlsx` workbook
3. `correct_interferences(mexp)`
4. `normalize_by_istd(mexp)` → `quantify_by_istd(mexp)`
5. `correct_drift_gaussiankernel(...)` → `correct_batch_centering(...)` (Dataset1 also shows `correct_drift_cubicspline` as an alternative)
6. `calc_qc_metrics(mexp, ...)` — QC stats; re-run after each change to inspect effects
7. `filter_features_qc(mexp, ...)` — drop features failing QC thresholds
8. `save_dataset_csv(mexp, ...)` — export final data

`plot_*` functions (`plot_runsequence`, `plot_runscatter`, `plot_pca`, `plot_rla_boxplot`, `plot_responsecurves`, `plot_qcmetrics_comparison`, `plot_qc_summary_*`, …) are read-only QC visualizations and don't mutate `mexp`. Many chunks build publication figures with `patchwork`/`ggplot2` and `ggsave` to `output/`.

## Conventions to preserve

- **Chunk labels are ordered and meaningful**: `chunkNN-short-description` (e.g. `chunk19-normalize-quantify`). Keep the numbering monotonic and labels descriptive when adding/reordering chunks.
- **Caching differs per notebook**: `Dataset3.qmd` sets `cache = TRUE` in its setup chunk (so `Dataset3_cache/` / `Dataset3_files/` exist locally and speed re-renders); `Dataset1.qmd` sets `cache = FALSE`. Render artifacts (`*_cache/`, `*_files/`, `output/`) are gitignored — don't commit them. Setup/import chunks pin `#| cache: false` to avoid stale state; preserve that.
- **Parallelism** uses `{mirai}` daemons (`mirai::daemons(8)`); plotting/QC functions pick these up automatically.
- Two notebooks differ only in scale/dataset: `Dataset1.qmd` (Supplementary Code 1 — 503 features × 937 samples, Tan et al.) and `Dataset3.qmd` (Supplementary Code 2 — 829 features × 4,591 samples, Chen et al.). Keep them parallel in structure; a change demonstrated in one usually belongs in the other. `Dataset1_TUTORIALqmd` is a divergent variant of Dataset1, not a generated file.
- New navbar pages must be registered in `_quarto.yml`; citations go through `references.bib` (`@key` syntax).
