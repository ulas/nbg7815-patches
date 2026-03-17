#!/usr/bin/env bash
set -euo pipefail

TOPDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JOBS="${JOBS:-$(nproc)}"

echo "TOPDIR: $TOPDIR"
echo "JOBS: $JOBS"

cd "$TOPDIR"

echo "[1/4] Cleaning target build artifacts to prevent kernel/kmod mixing"
make target/linux/clean
make package/kernel/linux/clean

echo "[2/4] Removing old target output and package indexes"
rm -rf "$TOPDIR/tmp"
rm -rf "$TOPDIR/bin/targets/qualcommax/ipq807x"
rm -rf "$TOPDIR/bin/packages/aarch64_cortex-a53"
find "$TOPDIR/staging_dir" -maxdepth 1 -type d -name 'target-*' -exec rm -rf {} +
find "$TOPDIR/build_dir" -maxdepth 1 -type d -name 'target-*' -exec rm -rf {} +

echo "[3/4] Refreshing config"
make defconfig

echo "[4/4] Building firmware and packages"
make -j"$JOBS" V=s

echo "Build finished successfully"
