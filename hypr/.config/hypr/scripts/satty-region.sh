#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/screenshots"
mkdir -p "$DIR"
OUT="$DIR/Screenshot-$(date +%F_%H-%M-%S).png"

REGION="$(slurp -c '#A667BAff')" || exit 1

grim -g "$REGION" - | satty --filename - --output-filename "$OUT"
