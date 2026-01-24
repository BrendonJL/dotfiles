#!/bin/bash

# Generate thumbnails for video wallpapers
# Run this whenever you add new wallpapers

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
THUMB_DIR="$WALLPAPER_DIR/thumbnails"

mkdir -p "$THUMB_DIR"

shopt -s nullglob 2>/dev/null || setopt nullglob 2>/dev/null
for video in "$WALLPAPER_DIR"/*.mp4 "$WALLPAPER_DIR"/*.mkv "$WALLPAPER_DIR"/*.webm; do
    [ -f "$video" ] || continue

    filename=$(basename "$video")
    name="${filename%.*}"
    thumb="$THUMB_DIR/$name.png"

    if [ ! -f "$thumb" ]; then
        echo "Generating thumbnail for: $name"
        # Grab frame at 1 second, scale to reasonable thumbnail size
        ffmpeg -y -ss 1 -i "$video" -vframes 1 -vf "scale=300:-1" "$thumb" 2>/dev/null
    else
        echo "Thumbnail exists: $name"
    fi
done

echo "Done!"
