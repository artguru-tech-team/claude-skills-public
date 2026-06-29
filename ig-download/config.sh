#!/usr/bin/env bash
# Resolves the default output dir for ig-download across machines.
# Priority: env override → Mac Drive mount → Windows G: drive → ~/Downloads/ig fallback

if [ -n "$IG_DOWNLOAD_DIR" ]; then
  echo "$IG_DOWNLOAD_DIR"
  exit 0
fi

MAC_DRIVE="$HOME/Library/CloudStorage/GoogleDrive-gharbimelek92@gmail.com/My Drive/obsidian/Melek's vault/03 - Resources/ig-downloads"
WIN_DRIVE="/g/My Drive/obsidian/Melek's vault/03 - Resources/ig-downloads"

if [ -d "$(dirname "$MAC_DRIVE")" ]; then
  mkdir -p "$MAC_DRIVE" && echo "$MAC_DRIVE"
elif [ -d "$(dirname "$WIN_DRIVE")" ]; then
  mkdir -p "$WIN_DRIVE" && echo "$WIN_DRIVE"
else
  mkdir -p "$HOME/Downloads/ig" && echo "$HOME/Downloads/ig"
fi
