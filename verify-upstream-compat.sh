#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_REPO_URL="${UPSTREAM_REPO_URL:-https://github.com/GreenSheep01201/claw-empire.git}"
PATCH_FILE="${PATCH_FILE:-$(pwd)/patches/system-panel-live.patch}"
TMP_DIR="$(mktemp -d /tmp/ce-system-panel-verify-XXXXXX)"
KEEP_TMP="${KEEP_TMP:-0}"

cleanup() {
  if [[ "$KEEP_TMP" != "1" ]]; then
    rm -rf "$TMP_DIR"
  fi
}
trap cleanup EXIT

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1"
    exit 1
  fi
}

require_cmd git
require_cmd pnpm

if [[ ! -f "$PATCH_FILE" ]]; then
  echo "Patch file not found: $PATCH_FILE"
  exit 1
fi

echo "[1/5] Cloning upstream: $UPSTREAM_REPO_URL"
git clone --depth 1 "$UPSTREAM_REPO_URL" "$TMP_DIR/repo" >/dev/null

echo "[2/5] Reading upstream HEAD"
UPSTREAM_HEAD="$(git -C "$TMP_DIR/repo" rev-parse HEAD)"
echo "Upstream HEAD: $UPSTREAM_HEAD"

echo "[3/5] Checking patch applicability"
git -C "$TMP_DIR/repo" apply --check "$PATCH_FILE"

echo "[4/5] Applying patch + installing deps"
git -C "$TMP_DIR/repo" apply --index "$PATCH_FILE"
pnpm -C "$TMP_DIR/repo" install --frozen-lockfile >/dev/null

echo "[5/5] Building"
pnpm -C "$TMP_DIR/repo" build >/dev/null

echo "Verification passed."
echo "Verified at: $(date -u +"%Y-%m-%d %H:%M UTC")"
echo "Upstream HEAD: $UPSTREAM_HEAD"
if [[ "$KEEP_TMP" == "1" ]]; then
  echo "Temp directory retained: $TMP_DIR"
fi
