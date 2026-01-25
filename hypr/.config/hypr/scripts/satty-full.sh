#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/screenshots"
mkdir -p "$DIR"
OUT="$DIR/Screenshot-$(date +%F_%H-%M-%S).png"

grim - | satty --filename - --output-filename "$OUT"
