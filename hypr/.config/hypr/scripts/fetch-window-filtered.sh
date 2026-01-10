#!/bin/bash
# Wrapper for pypr fetch_client_menu that filters out special workspaces

# Get all clients, filter out special workspaces, format nicely
# Format: "title||||address" so the address is hidden at the end
selected=$(hyprctl clients -j | jq -r '.[] | select(.workspace.name | startswith("special:") | not) | "\(.title)||||\(.address)"' | rofi -dmenu -i -p 'Window')

# Extract the address (after the ||||) and focus the window
if [ -n "$selected" ]; then
    address=$(echo "$selected" | cut -d'|' -f5)
    hyprctl dispatch focuswindow address:"$address"
fi
