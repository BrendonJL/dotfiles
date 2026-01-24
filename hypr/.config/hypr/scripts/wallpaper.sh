#!/bin/bash
killall hyprpaper 2>/dev/null

WALLPAPER=$(cat ~/.config/rofi/current_wallpaper 2>/dev/null)
# Fallback to default if no saved wallpaper
[ -z "$WALLPAPER" ] && WALLPAPER="/home/blasley/Pictures/Wallpapers/Animated_Chill_Cat.mp4"

killall mpvpaper 2>/dev/null
mpvpaper -o "no-audio loop keepaspect=no" '*' "$WALLPAPER" &

# Generate colors from wallpaper thumbnail using matugen
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
THUMB_DIR="$WALLPAPER_DIR/thumbnails"
WALLPAPER_NAME=$(basename "$WALLPAPER" | sed 's/\.[^.]*$//')
THUMBNAIL="$THUMB_DIR/$WALLPAPER_NAME.png"

if [ -f "$THUMBNAIL" ]; then
    ~/.cargo/bin/matugen image "$THUMBNAIL"
    # Restart waybar with new colors
    killall waybar 2>/dev/null
    waybar -c ~/.config/waybar/config &
    waybar -c ~/.config/waybar/config-laptop &
    waybar -c ~/.config/waybar/config-right &
    # Reload eww styles
    eww reload &
fi

