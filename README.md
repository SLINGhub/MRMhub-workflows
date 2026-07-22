# MRMhub Workflow Examples

Reproducible data-analysis notebooks demonstrating the
[**MRMhub**](https://github.com/SLINGhub/MRMhub) targeted LC-MS data-processing
pipeline on real datasets. Each workflow is a Quarto notebook combining narrative,
executable R and outputs, provided as Supplementary Materials for the MRMhub
manuscript (in preparation).

Rendered site: **[slinghub.github.io/MRMhub-workflows](https://slinghub.github.io/MRMhub-workflows)**.

## Workflows

- **Dataset 1** — targeted plasma lipidomics (Tan *et al.* 2022); 503 features across 937 samples.
- **Dataset 3** — targeted lipidomics (Chen *et al.* 2025); 829 features across 4,591 samples.
- **Dataset 4** — fully quantitative steroid assay (Panel 1, 15 analytes) with external calibration, low/high QC and EQA samples; validates MRMhub against Agilent MassHunter across the INTEGRATOR and QUANT modules.

## Data

The datasets are **not** included in this repository due to their size; they are
gitignored and archived on [Zenodo](https://zenodo.org/records/15370294) (record
**MRMhub-data**). Each dataset is a separate archive that unzips into
`data/dataset-<n>/`.

To obtain the data for a notebook:

1. Download the dataset archive from Zenodo — e.g. `MRMhub-Dataset1.zip`.
2. Unzip it **at the repository root** so the files land in `data/dataset-<n>/`:
   ```bash
   unzip MRMhub-Dataset1.zip -d .
   ```
3. Render the notebook, e.g. `quarto render Dataset1.qmd`.

Each `data/dataset-<n>/` folder carries a `README.txt` describing its files.
*(Dataset 4's data is pending upload to the same record.)*

## Software environment

The rendered site was produced with **[mrmhub](https://github.com/SLINGhub/MRMhub)
0.9.3** (the QUANT module) on **R 4.5** and **Quarto**. PDF output additionally
requires a LuaLaTeX engine (TinyTeX/TeX Live).

At the time of writing, the mrmhub 0.9.3 API used by these notebooks is on the
`development` branch (the package sits at the repository root there, so no
`subdir` is needed):

```r
remotes::install_github("SLINGhub/MRMhub", ref = "development")
```

> **Reproducibility note.** For an exact, immutable pin, install from a specific
> commit or release tag once a version carrying this API is published, e.g.
> `remotes::install_github("SLINGhub/MRMhub", ref = "<tag-or-sha>")`.

## Contact

bo.burla@nus.edu.sg and hyung_won_choi@nus.edu.sg
