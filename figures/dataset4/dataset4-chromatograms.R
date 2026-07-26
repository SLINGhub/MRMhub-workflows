# Generate the chromatogram illustration images for Dataset4.qmd.
#
# Crops single-sample cells from the MRMhub-INTEGRATOR `by_transition` PDFs and
# writes them as static PNGs under images/dataset4/. Dataset4.qmd embeds these
# pre-generated images, so the notebook render needs neither the PDFs nor magick
# / ghostscript. Re-run this script only when the example chromatograms change.
#
# Requires: magick (+ a ghostscript delegate for reading PDFs).
# Run from the repository root:  Rscript figures/dataset4/dataset4-chromatograms.R
#
# Inputs (by_transition PDFs + mzML_list.txt) live alongside this script in
# figures/dataset4/. The PDFs are gitignored (also archived in the full Dataset 4
# Zenodo upload); the generated PNGs are committed to images/dataset4/.

suppressPackageStartupMessages({
  library(magick)
  library(stringr)
})

fig_dir <- "figures/dataset4"
bt_dir  <- file.path(fig_dir, "by_transition")
out_dir <- "images/dataset4"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# Sample acquisition order — locates a sample's cell within a by_transition page.
mzml_assay <- str_remove(
  read.delim(file.path(fig_dir, "mzML_list.txt"), header = FALSE)[[1]],
  "[.]mzML$")

# The by_transition PDFs are a 2x2 grid per page: cell 1 is a title header, then
# one cell per sample in mzML_list order (row-major). Crop, trim and write one
# sample's cell as a PNG.
crop_cell <- function(pdf, analysis_id, nrow = 2, ncol = 2, density = 300) {
  ci   <- match(analysis_id, mzml_assay) + 1L        # +1 for the title cell
  per  <- nrow * ncol
  page <- ceiling(ci / per)
  pos  <- ((ci - 1) %% per) + 1
  row  <- ceiling(pos / ncol); col <- ((pos - 1) %% ncol) + 1
  img  <- image_read_pdf(file.path(bt_dir, pdf), pages = page, density = density)
  ii   <- image_info(img); cw <- ii$width / ncol; chh <- ii$height / nrow
  image_crop(img, sprintf("%.0fx%.0f+%.0f+%.0f",
                          cw, chh, (col - 1) * cw, (row - 1) * chh)) |>
    image_trim()
}

save_crop <- function(pdf, analysis_id, name) {
  image_write(crop_cell(pdf, analysis_id),
              path = file.path(out_dir, paste0(name, ".png")), format = "png")
  message("wrote ", name, ".png")
}

# Top-of-document example chromatograms: the three highlighted quantifiers at
# high (HQC) and low (LQC) QC levels.
for (a in list(c("21-deoxycortisol_0012.pdf",    "21-deoxycortisol"),
               c("11-deoxycortisol_0004.pdf",    "11-deoxycortisol"),
               c("Aldosterone_0017.pdf",         "Aldosterone"),
               c("Cortisol_D4_0030.pdf",         "CortisolD4"),
               c("Dihydrotestosterone_0051.pdf", "Dihydrotestosterone"))) {
  save_crop(a[1], "QC_High1_P1", paste0("top_", a[2], "_HQC"))
  save_crop(a[1], "QC_Low1_P1",  paste0("top_", a[2], "_LQC"))
}

# Figure 1 Panel D examples (the three highlighted, divergent-area cases).
save_crop("21-deoxycortisol_0012.pdf", "SKML2025_6B_P1", "fig1d_21-deoxycortisol")
save_crop("11-deoxycortisol_0004.pdf", "SKML2026_2B_P1", "fig1d_11-deoxycortisol")
save_crop("Aldosterone_0017.pdf",      "SKML2026_2A_P1", "fig1d_Aldosterone")
