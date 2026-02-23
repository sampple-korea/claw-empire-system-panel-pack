#!/usr/bin/env bash
set -euo pipefail

PATCH_URL="https://raw.githubusercontent.com/sampple-korea/claw-empire-system-panel-pack/main/patches/system-panel-live.patch"
PATCH_FILE="/tmp/system-panel-live.patch"

if [[ ! -f package.json || ! -d src || ! -d server ]]; then
  echo "Run this script from a Claw-Empire repository root."
  exit 1
fi

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1"
    exit 1
  fi
}

download_patch() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$PATCH_URL" -o "$PATCH_FILE"
    return
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -qO "$PATCH_FILE" "$PATCH_URL"
    return
  fi
  echo "Need curl or wget to download patch."
  exit 1
}

require_cmd git
require_cmd pnpm

download_patch

if git apply --reverse --check "$PATCH_FILE" >/dev/null 2>&1; then
  echo "Patch appears already applied in this repository. Skipping."
  exit 0
fi

git apply --index "$PATCH_FILE"
pnpm build

echo "Patch applied and build completed."
echo "Restart your service/process to load the new build."
