# Claw-Empire System Panel Patch Pack

This repository contains a standalone patch that adds the **live System Panel** to Claw-Empire.

## Included Changes
- `GET /api/system/metrics` and `GET /api/system/status`
- 5-minute metrics cache + manual refresh cooldown + stale cache fallback
- Linux temperature collection from `/sys/class/thermal` and `/sys/class/hwmon`
- Symlink-aware sensor scan (fixes "temperature unsupported" on boards like Raspberry Pi)
- Frontend System Panel view + sidebar/app wiring

## Apply In Any Claw-Empire Repo

Run these commands inside the target Claw-Empire repository root:

```bash
curl -L https://raw.githubusercontent.com/sampple-korea/claw-empire-system-panel-pack/main/patches/system-panel-live.patch -o /tmp/system-panel-live.patch
git apply --index /tmp/system-panel-live.patch
pnpm build
```

Then restart your service/process.

## Apply With Codex
Use this prompt to Codex:

```text
Apply the System Panel patch from https://github.com/sampple-korea/claw-empire-system-panel-pack.
Use patches/system-panel-live.patch, apply it to this repo, run build, and fix conflicts if any.
```

## Notes
- Patch was generated from commit `ee70320` of `GreenSheep01201/claw-empire`.
- If the target repo diverged significantly, resolve patch conflicts manually.
