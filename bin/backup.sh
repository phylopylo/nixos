#!/bin/bash

set -euo pipefail

NIX_CONFIG="/etc/nixos"
REPOSITORY_LOCATION="$(pwd)"
COMMIT_MESSAGE="Automated Update"
DEST_DIR="$1"

echo "=== COPYING ${NIX_CONFIG} to ${REPOSITORY_LOCATION}/${DEST_DIR} ==="

[ -d "${DEST_DIR}" ] && rm -rf "${DEST_DIR}"
cp -r "${NIX_CONFIG}" "${DEST_DIR}" || { echo "FAILURE TO COPY CONFIGURATION FILES."; exit 1; }

echo "=== COPIED ${NIX_CONFIG} to ${REPOSITORY_LOCATION}/${DEST_DIR} ==="
echo "=== PUSHING NEW NIX CONFIGURATION ==="

{
	git add "${DEST_DIR}" &&
	git commit -m "${COMMIT_MESSAGE}" &&
	git push
} || {
	echo "FAILURE TO PUSH TO REPOSITORY.";
	exit 1;
}

echo "=== SUCCESSFULLY PUSHED NEW NIX CONFIGURATION ==="

