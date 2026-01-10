#!/bin/bash
# ~/.config/hypr/scripts/toggle-claude.sh

# Check if Claude window exists
if hyprctl clients | grep -q "class: Claude"; then
    # If Claude window exists, check if it's visible
    if hyprctl activewindow | grep -q "class: Claude"; then
        # If Claude is active, close/hide it
        hyprctl dispatch killactive
    else
        # If Claude exists but not active, focus it
        hyprctl dispatch focuswindow "class:^(Claude)$"
    fi
else
    # If Claude doesn't exist, launch it
    claude-desktop &
fi