#!/bin/bash
killall mpvpaper 2>/dev/null
killall hyprpaper 2>/dev/null

WALLPAPER=$(cat ~/.config/rofi/current_wallpaper 2>/dev/null)
# Fallback to default if no saved wallpaper
[ -z "$WALLPAPER" ] && WALLPAPER="/home/blasley/.steam/steam/steamapps/workshop/content/431960/
3344234516/Animated background.mp4"

mpvpaper -o "no-audio loop keepaspect=no" '*' "$WALLPAPER" &

