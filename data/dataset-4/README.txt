Dataset 4 — fully quantitative steroid assay
============================================

Part of the MRMhub Workflow Examples (Supplementary Materials for the MRMhub
manuscript). Input data for the Dataset 4 analysis.

Assay: Steroid Panel 1, 15 analytes, externally calibrated absolute
quantification. MRMhub is compared against Agilent MassHunter at both the
INTEGRATOR (peak area) and QUANT (concentration) stages.
Read by: Dataset4.qmd (Supplementary Code 3) and Dataset4_Comparison.qmd.

Files
-----
Dataset4_MRMhub-INTEGRATOR_ASSAY.csv - INTEGRATOR peak areas, assay batch (blanks, calibrators, QCs, EQA samples)
Dataset4_MRMhub-INTEGRATOR_SST.csv - INTEGRATOR peak areas, system-suitability injections
Dataset4_IntegrationResults_MassHunter.csv - MassHunter re-integration of the same raw files (reference peak areas and concentrations), read by Dataset4_Comparison.qmd
Dataset4_MassHunter-CalibrationFits.csv - MassHunter calibration-curve fits (per-analyte fit model, weighting, coefficients, and R2 of MassHunter's own fit)
Dataset4_CalibrationCurves_MassHunter.csv - per-analyte MassHunter calibration curves in nmol/L. Provenance only: the source from which the fits above were transcribed.
Dataset4_CalibrationCurves_MassHunter.pdf - MassHunter's at-a-glance calibration-curve report. Provenance only; the CSV above is the authoritative per-analyte source.
Dataset4_MassHunter-V2.csv - earlier MassHunter export, retained for provenance; not read by any notebook
Dataset4_Metadata.xlsx - msorganiser metadata (analytes, samples, ISTDs, calibration/response curves, and the SKML EQA target concentrations in the "QC Concentrations" sheet)
Dataset4_SKML-EQA-expected-conc.xlsx - SKML ring-trial reference concentrations. Reference only: the values are registered into the metadata workbook by scripts/dataset4-eqa-to-metadata.R and read from the metadata at render time, not from here.

The two INTEGRATOR CSVs are the 'long.csv' files written by MRMhub-INTEGRATOR for
the assay and system-suitability batches, renamed for this repository.

Availability
------------
Unlike Datasets 1 and 3, these files are small enough to be tracked in the GitHub
repository, so Dataset4.qmd and Dataset4_Comparison.qmd render from a plain
git clone with no further downloads. They are also part of mrmhub-workflows.zip
in the Zenodo record below.

The raw mzML files, the MRMhub-INTEGRATOR application and all of its input files
are in MRMhub-Dataset4.zip in the same record, for re-running peak integration as
published or with new parameters. Not required to run Dataset4.qmd.

Source & citation
-----------------
Code: https://github.com/SLINGhub/MRMhub-workflows
Code & data deposit: https://doi.org/10.5281/zenodo.15370293 ("MRMhub-data")
Cite: MRMhub manuscript (in preparation).
License: CC BY 4.0 (data).
