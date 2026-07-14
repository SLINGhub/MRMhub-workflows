Dataset 1 — targeted plasma lipidomics
======================================

Part of the MRMhub Workflow Examples (Supplementary Materials for the MRMhub
manuscript). This archive holds the input data for the Dataset 1 analysis.

Study: Tan et al. 2022 (relative-quantification lipidomics panel).
Scale: 503 features x 937 samples.
Read by: Dataset1.qmd (Supplementary Code 1).

Files
-----
Dataset1_MRMhub-INTEGRATOR_Initial.csv - INTEGRATOR peak areas (initial integration)
Dataset1_MRMhub-INTEGRATOR_Final.csv - INTEGRATOR peak areas (final/reviewed integration)
Dataset1_Metadata.xlsx - msorganiser metadata (analytes, samples, ISTDs, response curves)

Usage
-----
These files are the input for the Dataset1.qmd analysis notebook.
1. Get the workflow code: git clone https://github.com/SLINGhub/mrmhub-workflows
2. Unzip this archive at the repository root; the files land in data/dataset-1/
3. Render: quarto render Dataset1.qmd
The repository gitignores the datasets (size), so they are distributed here.

Source & citation
-----------------
Code: https://github.com/SLINGhub/mrmhub-workflows
Data: Zenodo record "MRMhub-data" — https://zenodo.org/records/15370294
Cite: MRMhub manuscript (in preparation).
License: CC BY 4.0 (data).
