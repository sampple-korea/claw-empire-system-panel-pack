# Claw-Empire System Panel Patch Pack

Standalone patch pack to add a live **System Panel** to any compatible Claw-Empire repository.

## What this patch adds
- `GET /api/system/metrics` and `GET /api/system/status`
- 5-minute cache, manual refresh cooldown, stale-cache fallback
- Linux temperature sensors from `/sys/class/thermal` and `/sys/class/hwmon`
- Symlink-aware sensor scan (fixes unsupported temp on boards like Raspberry Pi)
- Frontend System Panel view + sidebar/app wiring

## Platform compatibility
- Linux runtime: full support including temperature sensors
- macOS runtime: metrics work, temperature is reported as unsupported by design
- Windows runtime: metrics work, temperature is reported as unsupported by design

## Apply patch (Linux/macOS)
Run inside target Claw-Empire repo root:

```bash
curl -fsSL https://raw.githubusercontent.com/sampple-korea/claw-empire-system-panel-pack/main/apply-system-panel.sh | bash
```

## Apply patch (Windows PowerShell)
Run inside target Claw-Empire repo root:

```powershell
irm https://raw.githubusercontent.com/sampple-korea/claw-empire-system-panel-pack/main/apply-system-panel.ps1 | iex
```

## Manual apply (Linux/macOS)
```bash
curl -fsSL https://raw.githubusercontent.com/sampple-korea/claw-empire-system-panel-pack/main/patches/system-panel-live.patch -o /tmp/system-panel-live.patch
git apply --index /tmp/system-panel-live.patch
pnpm build
```

## Manual apply (Windows PowerShell)
```powershell
iwr https://raw.githubusercontent.com/sampple-korea/claw-empire-system-panel-pack/main/patches/system-panel-live.patch -OutFile $env:TEMP\system-panel-live.patch
git apply --index $env:TEMP\system-panel-live.patch
pnpm build
```

After build, restart the Claw-Empire service/process.

## Codex prompt
```text
Apply the System Panel patch from https://github.com/sampple-korea/claw-empire-system-panel-pack.
Use patches/system-panel-live.patch, apply it to this repo, run build, and fix conflicts if needed.
```

## Update safety verification
- Last verified: `2026-02-23 16:34 UTC` (`2026-02-24 01:34 KST`)
- Upstream checked: `GreenSheep01201/claw-empire` HEAD `b37976627006616f50ede0930ff53d5ed5f57cc9`
- Validation run: `git apply --check`, `git apply --index`, `pnpm install --frozen-lockfile`, `pnpm build`
- Result: pass

## Maintainer re-check command
To re-validate against latest upstream:

```bash
./verify-upstream-compat.sh
```

## Notes
- Patch source commit: `ee70320` (generated from `GreenSheep01201/claw-empire`)
- If target repo diverged heavily, resolve patch conflicts manually.
