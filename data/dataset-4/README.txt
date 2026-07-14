Dataset 4 — fully quantitative steroid assay
============================================

Part of the MRMhub Workflow Examples (Supplementary Materials for the MRMhub
manuscript). This archive holds the input data for the Dataset 4 analysis.

Assay: Steroid Panel 1, 15 analytes, externally calibrated absolute
quantification. MRMhub is compared against Agilent MassHunter at both the
INTEGRATOR (peak area) and QUANT (concentration) stages.
Read by: Dataset4.qmd (Supplementary Code 3).

Files
-----
Dataset4_MRMhub-INTEGRATOR_ASSAY.csv - INTEGRATOR peak areas, assay batch (blanks, calibrators, QCs, EQA samples)
Dataset4_MRMhub-INTEGRATOR_SST.csv - INTEGRATOR peak areas, system-suitability injections
Dataset4_MassHunter-V2.csv - MassHunter re-integration of the same raw files (reference peak areas and concentrations)
Dataset4_MassHunter-CalibrationFits.csv - MassHunter calibration-curve fits (per-analyte fit model, weighting, coefficients, and R2 of MassHunter's own fit)
Dataset4_Metadata.xlsx - msorganiser metadata (analytes, samples, ISTDs, calibration/response curves, and the SKML EQA target concentrations in the "QC Concentrations" sheet)
Dataset4_SKML-EQA-expected-conc.xlsx - SKML ring-trial reference concentrations. Reference only: the values are registered into the metadata workbook by scripts/dataset4-eqa-to-metadata.R and read from the metadata at render time, not from here.

Usage
-----
These files are the input for the Dataset4.qmd analysis notebook.
1. Get the workflow code: git clone https://github.com/SLINGhub/MRMhub-workflows
2. Unzip this archive at the repository root; the files land in data/dataset-4/
3. Render: quarto render Dataset4.qmd
The repository gitignores the datasets (size), so they are distributed here.

Source & citation
-----------------
Code: https://github.com/SLINGhub/MRMhub-workflows
Data: Zenodo record "MRMhub-data" — https://zenodo.org/records/15370294 (Dataset 4 files pending upload)
Cite: MRMhub manuscript (in preparation).
License: CC BY 4.0 (data). 
