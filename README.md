# MRMhub Workflow Examples

Reproducible data analysis notebooks demonstrating the
[**MRMhub**](https://github.com/SLINGhub/MRMhub) targeted LC-MS data-processing
pipeline on real datasets. Each workflow is a Quarto notebook combining narrative,
executable R and outputs, provided as Supplementary Materials for the MRMhub
manuscript (in preparation).

Rendered site: **[slinghub.github.io/MRMhub-workflows](https://slinghub.github.io/MRMhub-workflows)**.

## Workflows

- **Dataset 1** — targeted plasma lipidomics (Tan *et al.* 2022); 503 features across 937 samples.
- **Dataset 3** — targeted lipidomics (Chen *et al.* 2025); 829 features across 4,591 samples.
- **Dataset 4** — fully quantitative steroid assay (Panel 1, 15 analytes) with external calibration, low/high QC and EQA samples. MRMhub-QUANT postprocessing: ISTD normalization, calibration, quantification and QC bias/variability against reference targets.
- **Dataset 4 — Comparison** — the same steroid assay, validating MRMhub against Agilent MassHunter across the INTEGRATOR (peak areas) and QUANT (concentrations) modules.

## Data and how to run

All code and data are deposited in a single Zenodo record,
[**10.5281/zenodo.15370293**](https://doi.org/10.5281/zenodo.15370293) (*MRMhub-data*).

**`mrmhub-workflows.zip`** — this complete repository *including* all data under
`data/`. Unzip it, open the project and run `quarto render`; nothing else is needed.
This is the recommended way to reproduce the workflows.

```bash
unzip mrmhub-workflows.zip && cd mrmhub-workflows
quarto render
```

**`MRMhub-Dataset1.zip`, `MRMhub-Dataset3.zip`, `MRMhub-Dataset4.zip`** — the raw mzML
files together with the MRMhub-INTEGRATOR application and all of its input files
(`param.txt`, feature/transition table, sample list), so peak integration can be re-run
exactly as published or with new parameters. **These are not needed to reproduce the
notebooks**: the workflows here start downstream of INTEGRATOR, from the `long.csv` it
produces, which is already included under `data/`. The record also holds
`MRMhub-Dataset2.zip`, a further dataset not used by these workflows.

### Running from a git clone

The Datasets 1 and 3 data exceed GitHub's file-size limit and are therefore **not** in
this git repository. A clone renders **Dataset 4 only**:

```bash
git clone https://github.com/SLINGhub/MRMhub-workflows
cd MRMhub-workflows
quarto render Dataset4.qmd            # works; data/dataset-4/ is tracked
quarto render Dataset4_Comparison.qmd # works
```

For Datasets 1 and 3 (and the manuscript figure, which is built from Dataset 1), use the
Zenodo bundle above. Each `data/dataset-<n>/` folder carries a `README.txt` describing
its files.

## Software environment

The rendered site was produced with **[mrmhub](https://github.com/SLINGhub/MRMhub)
0.9.9** (the QUANT module) on **R 4.5** and **Quarto**.

The notebooks render to HTML with no further setup. The PDF versions are typeset
with LuaLaTeX, which needs a TeX distribution installed — `quarto install tinytex`
provides a minimal one. Without it, render HTML only, e.g.
`quarto render Dataset1.qmd --to html`.

```r
if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")
pak::pak("SLINGhub/MRMhub")
```

> **Reproducibility note.** To install a fixed version, install from a specific
> commit or release tag once a version carrying this API is published, e.g.
> `pak::pak("SLINGhub/MRMhub@<tag-or-sha>")`.

## Licence

Code is MIT-licensed; the datasets under `data/` and the rendered site in `docs/` are
CC BY 4.0. See [LICENSE](LICENSE).

## Citation

Cite the Zenodo deposit, [10.5281/zenodo.15370293](https://doi.org/10.5281/zenodo.15370293)
— see [CITATION.cff](CITATION.cff) — together with the MRMhub manuscript (in preparation).

## Contact
Bo Burla (bo.burla@nus.edu.sg) and Hyungwon Choi (hyung_won_choi@nus.edu.sg)
