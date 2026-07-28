#!/usr/bin/env bash
#
# Build the Zenodo deposit: the complete workflows repository including all data.
#
#   scripts/build-zenodo-bundle.sh [ref]     # ref defaults to HEAD
#   -> dist/mrmhub-workflows.zip
#
# The archive is built from a *commit* (via `git archive`), not from the working
# tree, so its contents always correspond to a known revision. Everything git
# ignores — .git/, _freeze/, output/, *_cache/, *_files/, _archive/, .quarto/,
# dist/, .Rproj.user/, CLAUDE.md — is therefore excluded automatically. The
# Dataset 1 and Dataset 3 data are untracked (they exceed GitHub's file-size
# limit) and are copied in from the working tree afterwards.
#
# The resulting file replaces mrmhub-workflows.zip in Zenodo record
# https://doi.org/10.5281/zenodo.15370293

set -euo pipefail

VERSION="0.9.9"
REF="${1:-HEAD}"

REPO_ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
cd "$REPO_ROOT"

BUNDLE_NAME="mrmhub-workflows"
STAGE="dist/${BUNDLE_NAME}"
ZIP="dist/${BUNDLE_NAME}.zip"

# The bundle must correspond to a real commit, so refuse to build from a dirty tree.
if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: working tree is dirty — commit or stash first, so the bundle matches a revision." >&2
  git status --short >&2
  exit 1
fi

# The untracked bulk data must be present locally; without it the bundle is not runnable.
for f in \
  data/dataset-1/Dataset1_MRMhub-INTEGRATOR_Initial.csv \
  data/dataset-1/Dataset1_MRMhub-INTEGRATOR_Final.csv \
  data/dataset-1/Dataset1_Metadata.xlsx \
  data/dataset-3/Dataset3_MRMhub-INTEGRATOR_Final.csv \
  data/dataset-3/Dataset3_Metadata.xlsx
do
  if [[ ! -f "$f" ]]; then
    echo "error: missing $f — fetch the data from https://doi.org/10.5281/zenodo.15370293 first." >&2
    exit 1
  fi
done

rm -rf "$STAGE" "$ZIP"
mkdir -p "$STAGE"

echo "==> Exporting tracked files at ${REF}"
git archive --format=tar "$REF" | tar -x -C "$STAGE"

echo "==> Adding untracked Dataset 1 and Dataset 3 data"
rsync -a --exclude '.DS_Store' data/dataset-1/ "$STAGE/data/dataset-1/"
rsync -a --exclude '.DS_Store' data/dataset-3/ "$STAGE/data/dataset-3/"

echo "==> Writing MANIFEST.txt"
{
  echo "MRMhub Workflow Examples — Zenodo deposit"
  echo "========================================="
  echo
  echo "Version:    ${VERSION}"
  echo "Git ref:    ${REF} ($(git rev-parse --short "$REF"))"
  echo "Commit:     $(git rev-parse "$REF")"
  echo "Built:      $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo "mrmhub:     $(Rscript -e 'cat(as.character(utils::packageVersion("mrmhub")))' 2>/dev/null || echo 'not installed')"
  echo "Deposit:    https://doi.org/10.5281/zenodo.15370293"
  echo "Source:     https://github.com/SLINGhub/MRMhub-workflows"
  echo
  echo "This archive is the complete workflows repository with all data included."
  echo "Unzip it, open mrmhub-workflows.Rproj (or cd into the folder) and run:"
  echo
  echo "    quarto render"
  echo
  echo "See README.md for the software environment, and data/dataset-*/README.txt"
  echo "for a description of each dataset."
  echo
  echo "Contents"
  echo "--------"
  du -sh "$STAGE"/* | sed "s|$STAGE/||"
} > "$STAGE/MANIFEST.txt"

echo "==> Zipping"
(cd dist && zip -q -r "${BUNDLE_NAME}.zip" "$BUNDLE_NAME")
rm -rf "$STAGE"

echo
echo "Built ${ZIP} ($(du -h "$ZIP" | cut -f1), $(unzip -l "$ZIP" | tail -1 | awk '{print $2}') files)"
echo "Upload it to https://doi.org/10.5281/zenodo.15370293, replacing the existing mrmhub-workflows.zip."
