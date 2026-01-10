#!/bin/bash
# Toggle battery popup with cursor-relative positioning

# Get cursor position
cursor_info=$(hyprctl cursorpos -j)
X=$(echo "$cursor_info" | jq -r '.x')
Y=$(echo "$cursor_info" | jq -r '.y')

# Get the monitor the cursor is on
monitor_info=$(hyprctl monitors -j | jq -r --argjson x "$X" --argjson y "$Y" '
    .[] | select(.x <= $x and $x < (.x + .width) and .y <= $y and $y < (.y + .height)) | .name
')

# Get monitor X offset to make coordinates relative to that monitor
monitor_x_offset=$(hyprctl monitors -j | jq -r --arg name "$monitor_info" '.[] | select(.name == $name) | .x')
monitor_y_offset=$(hyprctl monitors -j | jq -r --arg name "$monitor_info" '.[] | select(.name == $name) | .y')

# Calculate position relative to the monitor
popup_x=$((X - monitor_x_offset - 68))
popup_y=-5

# Keep popup on screen (don't go negative)
[[ $popup_y -lt 0 ]] && popup_y=1

# Check if already open, close it
if eww active-windows | grep -q 'battery_popup'; then
    eww close battery_popup
else
    # Close any other open popups first
    eww close audio_popup bluetooth_popup network_popup display_popup system_popup calendar_popup workspace_popup power_popup month_picker year_picker event_details event_editor confirm_dialog 2>/dev/null
    eww open battery_popup --screen "$monitor_info" --pos "${popup_x}x${popup_y}"
fi