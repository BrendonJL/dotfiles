#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/screenshots"
mkdir -p "$DIR"
OUT="$DIR/Screenshot-$(date +%F_%H-%M-%S).png"

# Current workspace id
WS="$(hyprctl activewindow -j | jq -r '.workspace.id // empty')"

# If there's no active window/workspace, fall back to region select
if [[ -z "${WS}" ]]; then
  REGION="$(slurp -c '#A667BAff')" || exit 1
else
  # Build a list of window rectangles on the current workspace and let slurp pick one. :contentReference[oaicite:2]{index=2}
  REGION="$(
    hyprctl clients -j |
      jq -r --argjson ws "$WS" '.[] | select(.mapped == true) | select(.workspace.id == $ws) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' |
      slurp -c '#A667BAff'
  )" || exit 1
fi

grim -g "$REGION" -t ppm - |
  satty --filename - \
    --copy-command "wl-copy -t image/png" \
    --output-filename "$OUT" \
    --actions-on-enter "save-to-clipboard,save-to-file,exit" \
    --actions-on-escape "exit" \
    --early-exit

command -v dunstify >/dev/null 2>&1 && dunstify "Screenshot" "Saved + copied: $(basename "$OUT")" -t 1200 || true
EOF
