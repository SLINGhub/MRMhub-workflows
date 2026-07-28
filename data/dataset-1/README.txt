Dataset 1 — targeted plasma lipidomics
======================================

Part of the MRMhub Workflow Examples (Supplementary Materials for the MRMhub
manuscript). Input data for the Dataset 1 analysis.

Study: Tan et al. 2022 (relative-quantification lipidomics panel).
Scale: 503 features x 937 samples.
Read by: Dataset1.qmd (Supplementary Code 1) and ManuscriptFigure.qmd.

Files
-----
Dataset1_MRMhub-INTEGRATOR_Initial.csv - INTEGRATOR peak areas (initial integration)
Dataset1_MRMhub-INTEGRATOR_Final.csv - INTEGRATOR peak areas (final/reviewed integration)
Dataset1_Metadata.xlsx - msorganiser metadata (analytes, samples, ISTDs, response curves)

The two INTEGRATOR CSVs are the 'long.csv' files written by MRMhub-INTEGRATOR,
renamed for this repository.

Availability
------------
These files exceed GitHub's file-size limit and are therefore not part of the
GitHub repository. They are included in mrmhub-workflows.zip - the complete
workflows repository with all data - in the Zenodo record below. Unzip it and
run: quarto render Dataset1.qmd

The raw mzML files, the MRMhub-INTEGRATOR application and all of its input files
are in MRMhub-Dataset1.zip in the same record, for re-running peak integration as
published or with new parameters. Not required to run Dataset1.qmd.

Source & citation
-----------------
Code: https://github.com/SLINGhub/MRMhub-workflows
Code & data deposit: https://doi.org/10.5281/zenodo.15370293 ("MRMhub-workflows")
Cite: MRMhub manuscript (in preparation).
License: CC BY 4.0 (data).
