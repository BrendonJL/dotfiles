#!/bin/bash
# ~/.config/waybar/display-waybar.sh
# Outputs JSON for waybar with external monitor status

get_monitor_count() {
    # Count connected monitors (excluding internal laptop displays)
    hyprctl monitors -j | jq 'length'
}

monitor_count=$(get_monitor_count)
icon="󰍹"

if [[ $monitor_count -gt 1 ]]; then
    class="display-connected"
    tooltip="󰍹 ${monitor_count} displays connected"
elif [[ $monitor_count -eq 1 ]]; then
    # Check if it's just the built-in or an external
    monitor_name=$(hyprctl monitors -j | jq -r '.[0].name')
    if [[ "$monitor_name" == "eDP-1" || "$monitor_name" == "eDP-2" ]]; then
        class="display-none"
        tooltip="󰍹 No external displays"
    else
        class="display-connected"
        tooltip="󰍹 ${monitor_name}"
    fi
else
    class="display-none"
    tooltip="󰍹 No displays detected"
fi

# Output JSON for waybar
echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"