#!/bin/bash
set -u
cd ~/github/clip2earn || exit 1

echo '=== Suppression worktrees MERGED + OLD ==='
TO_REMOVE=(
  "/home/melek/github/clip2earn-test-coverage"
  "/home/melek/github/clip2earn/.claude/worktrees/feat+campaign-manager-inbox-timeline"
  "/home/melek/github/clip2earn/.claude/worktrees/feat+campaign-manager-primitives"
  "/home/melek/github/clip2earn/.claude/worktrees/fix+creator-wallet"
  "/home/melek/github/clip2earn/.claude/worktrees/pr-563-rebase"
  "/home/melek/github/fix-bulk-validations"
  "/home/melek/github/fix/base-payment"
  "/tmp/pr884-fix"
  "/var/tmp/vibe-kanban/worktrees/5b51-bmad-help-refact/clip2earn"
)

for WT in "${TO_REMOVE[@]}"; do
  echo "--- $WT ---"
  if [ -d "$WT" ]; then
    git worktree remove --force "$WT" 2>/dev/null || rm -rf "$WT"
    echo "  removed"
  else
    git worktree remove --force "$WT" 2>/dev/null
    echo "  not on disk (entry pruned)"
  fi
done

echo
echo '=== git worktree prune ==='
git worktree prune -v

echo
echo '=== Nuke node_modules (B): worktrees actifs + main repos hors clip2earn principal ==='
# Worktrees actifs restants : nuke node_modules
for WT in /home/melek/github/clip2earn/.claude/worktrees/*/; do
  NM="$WT/node_modules"
  if [ -d "$NM" ]; then
    SIZE=$(du -sh "$NM" 2>/dev/null | cut -f1)
    rm -rf "$NM"
    echo "  removed $NM ($SIZE)"
  fi
done

# Bakchich repos
for NM in \
  /home/melek/github/bakchich-business/bakchich-ads-backend/node_modules \
  /home/melek/github/bakchich-business/bakchich-ads-client/node_modules \
  /home/melek/github/bakchich-business/bakchich-business-landing-page/node_modules \
  /home/melek/github/bakchich-admin-dashboard/node_modules \
  /home/melek/github/bakchich-core/bakchich-monorepo/node_modules \
  ; do
  if [ -d "$NM" ]; then
    SIZE=$(du -sh "$NM" 2>/dev/null | cut -f1)
    rm -rf "$NM"
    echo "  removed $NM ($SIZE)"
  fi
done

echo
echo '=== Force-nuke ~/.npm (D) ==='
du -sh ~/.npm 2>/dev/null
rm -rf ~/.npm
echo "~/.npm removed"

echo
echo '=== Final ==='
df -h /
echo
du -sh ~/github/clip2earn 2>/dev/null
