#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# 1. Check input arguments
if [ -z "$1" ]; then
    echo "ERROR: Target name is required."
    echo "Valid options: ls1046apscbx5 | ls1046apscbc | ls1046apxcp"
    echo "Usage: ./scripts/sync_deb.sh <target_name>"
    exit 1
fi

TARGET=$1

# 2. Target validation (Whitelist check)
if [[ "$TARGET" != "ls1046apscbx5" && "$TARGET" != "ls1046apscbc" && "$TARGET" != "ls1046apxcp" ]]; then
    echo "ERROR: Unsupported target name '$TARGET'"
    echo "Valid options are:"
    echo "  - ls1046apscbx5"
    echo "  - ls1046apscbc"
    echo "  - ls1046apxcp"
    exit 1
fi

# 3. Define short name mapping for the specific kernel file
SHORT_NAME=""
case "$TARGET" in
    "ls1046apscbc")   SHORT_NAME="pscbc" ;;
    "ls1046apscbx5")  SHORT_NAME="pscbx5" ;; 
    "ls1046apxcp")    SHORT_NAME="pxcp" ;;   
esac

# 4. Get current date (Format: YYYYMMDD)
CURRENT_DATE=$(date +%Y%m%d)

# 5. Define source and destination directories
SRC_DEB_DIR="$(pwd)/build/tmp/deploy/deb/"
DST_DEB_DIR="$HOME/www/${TARGET}/deb/"

SRC_IMG_DIR="$(pwd)/build/tmp/deploy/images/${TARGET}/"
DST_IMG_DIR="$HOME/www/${TARGET}/images/${CURRENT_DATE}/"

# Path validation safety check
if [ ! -d "$SRC_DEB_DIR" ] || [ ! -d "$SRC_IMG_DIR" ]; then
    echo "ERROR: Source directory not found. Please ensure you are running this script from the 'kas-build' root directory."
    echo "Checked source deb dir: $SRC_DEB_DIR"
    echo "Checked source images dir: $SRC_IMG_DIR"
    exit 1
fi

# Create target directories if they do not exist
mkdir -p "$DST_DEB_DIR"
mkdir -p "$DST_IMG_DIR"

echo "========================================="
echo "Current Execution Path: $(pwd)"
echo "Current System Date   : $CURRENT_DATE"
echo "Target Board Name     : $TARGET"
echo "========================================="

# =========================================================
# Phase 1: Sync DEB Packages
# =========================================================
echo ">>> Step 1/2: Starting DEB package sync..."

EXCLUDE_ARGS=()
[[ "$TARGET" != "ls1046apscbx5" ]] && EXCLUDE_ARGS+=(--exclude="ls1046apscbx5")
[[ "$TARGET" != "ls1046apscbc" ]]  && EXCLUDE_ARGS+=(--exclude="ls1046apscbc")
[[ "$TARGET" != "ls1046apxcp" ]]   && EXCLUDE_ARGS+=(--exclude="ls1046apxcp")
EXCLUDE_ARGS+=(--exclude="ls1046apscb")

rsync -avz --delete "${EXCLUDE_ARGS[@]}" "$SRC_DEB_DIR" "$DST_DEB_DIR"

# =========================================================
# Phase 2: Sync Image Files (With Symlink Resolution)
# =========================================================
echo ">>> Step 2/2: Starting Image file sync..."

# Added '-L' flag to copy the real file content instead of the symlink pointer
rsync -avzL \
    --include="boot_${TARGET}_lts_6.6.tgz" \
    --include="firmware_${TARGET}_uboot_emmcboot.img" \
    --include="firmware_${TARGET}_uboot_qspiboot.img" \
    --include="firmware_${TARGET}_uboot_sdboot.img" \
    --include="flex-installer" \
    --include="pico-sdk-ls1046a-${TARGET}.rootfs.tar.gz" \
    --include="kernel-fsl-ls1046a-${SHORT_NAME}-sdk.itb" \
    --exclude="*" \
    "$SRC_IMG_DIR" "$DST_IMG_DIR"

echo "========================================="
echo "All sync tasks completed successfully!"
echo "DEB Directory   : $DST_DEB_DIR"
echo "Images Directory: $DST_IMG_DIR"
echo "========================================="
