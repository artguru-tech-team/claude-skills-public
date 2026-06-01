---
name: wsl-disk-cleanup
description: Use when C: drive is full or low on Windows with WSL2. Reclaims space from bloated Ubuntu/Docker .vhdx files via fstrim + diskpart compact. Also cleans Notion/npm/Temp/Playwright caches and merged/old git worktrees with their node_modules. Triggers on "C: plein", "espace disque", "free disk space", "vhdx", "WSL takes too much space", "compact wsl".
visibility: public
---

# WSL Disk Cleanup Playbook

Validated 2026-05-02 on MELEKGHARBI-01: **2.97 GB → 143.11 GB free (+186 GB total)** in one session.

## When to use
- C: drive low / red bar in Explorer
- WSL Ubuntu / Docker `.vhdx` larger than 50 GB
- After heavy dev work with multiple worktrees + node_modules accumulating

## Mental model — the gotchas

1. **`.vhdx` files don't shrink automatically.** WSL allocates blocks but never returns them, even when you delete files inside Linux.
2. **`diskpart compact` alone does nothing on ext4.** Linux marks blocks as free but doesn't zero or trim them. Windows still sees the blocks as "used".
3. **You MUST `sudo fstrim -av` inside WSL first.** This tells the host's vhdx layer which blocks are sparse. Then compact actually works.
4. **`dd zerofill` is a foot-gun.** WSL Ubuntu shows ~1 TB free even when only 30 GB used (sparse vhdx). `dd` will try to write the full ~1 TB of zeros, crashing C: in the process. Always cap with `bs=1M count=N`. Prefer fstrim.
5. **`LxssManager` / `vmcompute` services lock the vhdx** even after `wsl --shutdown`. Stop them in admin before diskpart.
6. **Docker Desktop auto-restarts WSL.** Quit it from system tray before compacting.

## Order of operations

### Phase 1 — Diagnostic (read-only)
```powershell
# Free space
(Get-PSDrive C).Free / 1GB

# All vhdx with sizes
Get-ChildItem 'C:\Users\<user>' -Recurse -Force -Filter *.vhdx -ErrorAction SilentlyContinue |
  Sort-Object Length -Descending |
  ForEach-Object { '{0,8:N2} GB  {1}' -f ($_.Length/1GB), $_.FullName }

# Top folders inside C:\Users\<user>
Get-ChildItem 'C:\Users\<user>' -Directory -Force | ForEach-Object {
  $size = (Get-ChildItem $_.FullName -Recurse -Force -File -EA 0 | Measure-Object -Property Length -Sum).Sum
  [PSCustomObject]@{ GB=[math]::Round($size/1GB,2); Path=$_.FullName }
} | Sort-Object GB -Descending | Select-Object -First 20
```

Inside WSL:
```bash
df -h /
du -sh ~/* 2>/dev/null | sort -hr | head
docker system df 2>/dev/null    # if docker installed inside WSL
```

### Phase 2 — Windows-side caches (safe, no admin)
| Target | Method | Typical |
|---|---|---|
| `%APPDATA%\Notion\Partitions\notion` | `Remove-Item` (close Notion app first) | 5-8 GB |
| `%LOCALAPPDATA%\npm-cache` | `npm cache clean --force` | 5-10 GB |
| `%LOCALAPPDATA%\Temp` | `Get-ChildItem | Remove-Item` | 3-8 GB |
| `%LOCALAPPDATA%\ms-playwright` | full delete (reinstall via `npx playwright install`) | 1-2 GB |

⚠️ Sandbox blocks `Remove-Item 'C:\Users\<user>\AppData\Local\npm-cache\*'` directly — use `npm cache clean --force` via the npm CLI instead.

### Phase 3 — Inside WSL
```bash
# Audit worktrees (script below)
bash worktree_audit.sh

# Cleanup mergees + old + node_modules + ~/.npm
bash worktree_cleanup.sh

# Docker prune (if docker-desktop)
docker system prune -a --volumes -f
```

### Phase 4 — TRIM (the magic step)
```bash
sudo fstrim -av
# Expected: "/: XXX GiB trimmed on /dev/sdc"
# The bigger the GiB number, the more compact will recover
```

### Phase 5 — Compact (PowerShell admin)
```powershell
# Quit Docker Desktop, close all WSL terminals, close VS Code/Cursor with WSL
.\compact_ubuntu_only.ps1
```

The script:
1. Kills Docker Desktop processes
2. `wsl --shutdown`
3. Stops `LxssManager` + `vmcompute` + `WSLService`
4. `diskpart compact vdisk` on each vhdx
5. Restarts services
6. Reports gain

## Worktree cleanup strategy

For a repo with many `.claude/worktrees/*`:
- Detect default branch via `git symbolic-ref refs/remotes/origin/HEAD`
- For each worktree: check if branch ancestor of default → MERGED
- Else check `git log origin/default..branch` empty → MERGED?
- Else check age of last commit → OLD>30d / OLD>14d / ACTIVE
- Delete MERGED + OLD>14d entirely (`git worktree remove --force`)
- For ACTIVE: keep but `rm -rf node_modules` (reinstall via `pnpm install` later)

## Reusable scripts

All in `scripts/` next to this SKILL.md:
- `scan_wsl.sh` — disk usage scan inside WSL (no sudo)
- `worktree_audit.sh` — git worktree status + age + size
- `worktree_cleanup.sh` — delete merged/old worktrees + nuke node_modules + ~/.npm
- `compact_ubuntu_only.ps1` — admin compact script with service stop

Adjust the hardcoded paths (Ubuntu distro folder, github repo paths) for the target machine before running.

## Post-cleanup verification
```powershell
(Get-PSDrive C).Free / 1GB
Get-ChildItem 'C:\Users\<user>' -Recurse -Force -Filter *.vhdx | Sort-Object Length -Descending
```

## Recurring maintenance

Schedule monthly:
1. `sudo fstrim -av` inside WSL
2. `compact_ubuntu_only.ps1` in admin

WSL2 has `wsl --manage <distro> --set-sparse true` (Win 11 24H2+) which automates step 1 — check if available before going manual.
