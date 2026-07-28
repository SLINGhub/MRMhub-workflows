by_transition — MRMhub-INTEGRATOR per-transition integration plots (Dataset 4)
=============================================================================

These 61 PDF files are the per-transition integration plots exported by
MRMhub-INTEGRATOR for the Dataset 4 steroid assay. They are the INPUT to the
figure-generation script in this folder (dataset4-chromatograms.R), which crops
example chromatograms from them into images/dataset4/*.png.

The PDFs are NOT tracked in git (they are large and regenerable/archived). The
committed PNGs in images/dataset4/ are enough to render Dataset4_Comparison.qmd; you only
need these PDFs to RE-GENERATE those figures.

How to obtain the PDFs
----------------------
Download MRMhub-Dataset4.zip from the Zenodo record "MRMhub-data":

    https://doi.org/10.5281/zenodo.15370293

That archive holds the raw mzML files, the MRMhub-INTEGRATOR application and its
input files, and these by_transition PDFs. Unzip it and place all *.pdf files
into this folder:

    scripts/dataset4-chromatograms/by_transition/

Then regenerate the figures from the repository root:

    Rscript scripts/dataset4-chromatograms/dataset4-chromatograms.R
