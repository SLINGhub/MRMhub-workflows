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
Download the Dataset 4 archive from Zenodo (record "MRMhub-data"):

    https://zenodo.org/records/15370294

The by_transition PDFs are included in the full Dataset 4 upload (with the raw
mzML files). Unzip and place all *.pdf files into this folder:

    scripts/dataset4-chromatograms/by_transition/

Then regenerate the figures from the repository root:

    Rscript scripts/dataset4-chromatograms/dataset4-chromatograms.R

Note: the Dataset 4 data is not yet on Zenodo at the time of writing; it will be
deposited in the same record.
