Dataset 3 — targeted lipidomics
===============================

Part of the MRMhub Workflow Examples (Supplementary Materials for the MRMhub
manuscript). Input data for the Dataset 3 analysis.

Study: Chen et al. 2025 (relative-quantification lipidomics panel).
Scale: 829 features x 4,591 samples.
Read by: Dataset3.qmd (Supplementary Code 2).

Files
-----
Dataset3_MRMhub-INTEGRATOR_Final.csv - INTEGRATOR peak areas
Dataset3_Metadata.xlsx - msorganiser metadata (analytes, samples, ISTDs, response curves)

The INTEGRATOR CSV is the 'long.csv' file written by MRMhub-INTEGRATOR, renamed
for this repository.

Availability
------------
These files exceed GitHub's file-size limit and are therefore not part of the
GitHub repository. They are included in mrmhub-workflows.zip - the complete
workflows repository with all data - in the Zenodo record below. Unzip it and
run: quarto render Dataset3.qmd

The raw mzML files, the MRMhub-INTEGRATOR application and all of its input files
are in MRMhub-Dataset3.zip in the same record, for re-running peak integration as
published or with new parameters. Not required to run Dataset3.qmd.

Source & citation
-----------------
Code: https://github.com/SLINGhub/MRMhub-workflows
Code & data deposit: https://doi.org/10.5281/zenodo.15370293 ("MRMhub-data")
Cite: MRMhub manuscript (in preparation).
License: CC BY 4.0 (data).
