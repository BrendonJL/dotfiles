#!/bin/bash

# Start eww daemon FIRST
eww daemon &
sleep 2

# Check if all monitors are detected
MONITOR_COUNT=$(hyprctl monitors -j | jq '. | length')
echo "Detected $MONITOR_COUNT monitors" >>/tmp/startup-debug.log

# Open splash only on monitors that exist
eww open splash &
if [ "$MONITOR_COUNT" -ge 2 ]; then eww open splash-1 & fi
if [ "$MONITOR_COUNT" -ge 3 ]; then eww open splash-2 & fi

# Set cursor theme
hyprctl setcursor catppuccin-mocha-mauve-cursors 24

# Background services
systemctl --user start plasma-polkit-agent

# Wait for D-Bus and tray to initialize
sleep 2

# Start KDE Connect
kdeconnectd &
sleep 1
kdeconnect-indicator &

# Wait for tray to settle
sleep 1

# Start waybar for each monitor
waybar -c ~/.config/waybar/config &
waybar -c ~/.config/waybar/config-right &
waybar -c ~/.config/waybar/config-laptop &
sleep 1

swaync &

# Suricata notifications
~/.config/hypr/scripts/suricata-notify.sh &

# Kill xwaylandvideobridge if it auto-started
pkill -f xwaylandvideobridge

sleep 5
killall eww

# Restart eww daemon for your other widgets
sleep 1
eww daemon &
sleep 1
