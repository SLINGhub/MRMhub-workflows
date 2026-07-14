Dataset 3 — targeted lipidomics
===============================

Part of the MRMhub Workflow Examples (Supplementary Materials for the MRMhub
manuscript). This archive holds the input data for the Dataset 3 analysis.

Study: Chen et al. 2025 (relative-quantification lipidomics panel).
Scale: 829 features x 4,591 samples.
Read by: Dataset3.qmd (Supplementary Code 2).

Files
-----
Dataset3_MRMhub-INTEGRATOR_20251010.csv - INTEGRATOR peak areas
Dataset3_Metadata_20251010.xlsx - msorganiser metadata (analytes, samples, ISTDs, response curves)

Usage
-----
These files are the input for the Dataset3.qmd analysis notebook.
1. Get the workflow code: git clone https://github.com/SLINGhub/mrmhub-workflows
2. Unzip this archive at the repository root; the files land in data/dataset-3/
3. Render: quarto render Dataset3.qmd
The repository gitignores the datasets (size), so they are distributed here.

Source & citation
-----------------
Code: https://github.com/SLINGhub/mrmhub-workflows
Data: Zenodo record "MRMhub-data" — https://zenodo.org/records/15370294
Cite: MRMhub manuscript (in preparation).
License: CC BY 4.0 (data).
