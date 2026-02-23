#!/usr/bin/env bash
set -euo pipefail

PATCH_URL="https://raw.githubusercontent.com/sampple-korea/claw-empire-system-panel-pack/main/patches/system-panel-live.patch"
PATCH_FILE="/tmp/system-panel-live.patch"

if [[ ! -f package.json ]]; then
  echo "Run this script from the target Claw-Empire repo root."
  exit 1
fi

curl -L "$PATCH_URL" -o "$PATCH_FILE"
git apply --index "$PATCH_FILE"
pnpm build

echo "Patch applied and build completed. Restart your service now."
