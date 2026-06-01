#!/bin/bash
echo '=== /home top ==='
du -h --max-depth=2 /home 2>/dev/null | sort -hr | head -15
echo
echo '=== Suspects user ==='
for p in "$HOME/.cache" "$HOME/.npm" "$HOME/.yarn" "$HOME/.pnpm-store" \
         "$HOME/.cargo" "$HOME/.rustup" "$HOME/anaconda3" "$HOME/miniconda3" \
         "$HOME/.conda" "$HOME/.local/share" "$HOME/go" \
         "$HOME/.vscode-server" "$HOME/.cursor-server" "$HOME/.bun" \
         "$HOME/.deno" "$HOME/.nvm" "$HOME/.pyenv" "$HOME/Downloads"; do
  [ -e "$p" ] && du -sh "$p" 2>/dev/null
done
echo
echo '=== Suspects system (lecture seule, errors silencieuses) ==='
for p in /var/lib/docker /var/cache/apt /var/log /tmp /var/tmp /opt /usr/local; do
  du -sh "$p" 2>/dev/null
done
echo
echo '=== Free space inside WSL ==='
df -h /
echo
echo '=== Docker disk usage (si docker actif) ==='
docker system df 2>/dev/null || echo '(docker non disponible sans sudo)'
