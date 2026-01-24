#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/screenshots"
mkdir -p "$DIR"
OUT="$DIR/Screenshot-$(date +%F_%H-%M-%S).png"

REGION="$(slurp -c '#A667BAff')" || exit 1

grim -g "$REGION" -t ppm - |
  satty --filename - \
    --copy-command "wl-copy -t image/png" \
    --output-filename "$OUT" \
    --actions-on-enter "save-to-clipboard,save-to-file,exit" \
    --actions-on-escape "exit" \
    --early-exit

command -v dunstify >/dev/null 2>&1 && dunstify
