#!/bin/bash
cd ~/github/clip2earn || exit 1

echo '=== Git fetch (pour avoir un main à jour) ==='
git fetch --all --prune 2>&1 | tail -5
echo

# Trouver branche par défaut
DEFAULT=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
[ -z "$DEFAULT" ] && DEFAULT=main
echo "Branche principale détectée : $DEFAULT"
echo

echo '=== Worktrees ==='
git worktree list
echo

echo '=== Audit par worktree ==='
printf "%-12s %-50s %-20s %-12s %-10s\n" "STATUT" "WORKTREE" "BRANCHE" "DERNIER_COMMIT" "TAILLE"
echo "------------------------------------------------------------------------------------------------------------"

git worktree list --porcelain | awk '/^worktree /{wt=$2} /^branch /{br=$2; print wt"|"br}' | while IFS='|' read -r WT BR; do
  [ "$WT" = "$(pwd)" ] && continue  # skip main
  BR_SHORT="${BR#refs/heads/}"
  LAST_COMMIT=$(git -C "$WT" log -1 --format=%cd --date=short 2>/dev/null)
  AGE_DAYS=$(( ( $(date +%s) - $(git -C "$WT" log -1 --format=%ct 2>/dev/null || echo 0) ) / 86400 ))
  SIZE=$(du -sh "$WT" 2>/dev/null | cut -f1)

  # Mergée dans main ?
  if git merge-base --is-ancestor "$BR" "origin/$DEFAULT" 2>/dev/null; then
    STATUT="MERGED"
  elif [ -z "$(git -C "$WT" log "origin/$DEFAULT".."$BR" --oneline 2>/dev/null)" ]; then
    STATUT="MERGED?"
  elif [ "$AGE_DAYS" -gt 30 ]; then
    STATUT="OLD>30d"
  elif [ "$AGE_DAYS" -gt 14 ]; then
    STATUT="OLD>14d"
  else
    STATUT="ACTIVE"
  fi

  printf "%-12s %-50s %-20s %-12s %-10s\n" "$STATUT" "$(basename $WT)" "$BR_SHORT" "$LAST_COMMIT" "$SIZE"
done
