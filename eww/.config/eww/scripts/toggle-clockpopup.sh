#!/bin/bash
# Toggle calendar popup with cursor-relative positioning

# Get cursor position
cursor_info=$(hyprctl cursorpos -j)
X=$(echo "$cursor_info" | jq -r '.x')
Y=$(echo "$cursor_info" | jq -r '.y')

# Get the monitor the cursor is on
monitor_info=$(hyprctl monitors -j | jq -r --argjson x "$X" --argjson y "$Y" '
    .[] | select(.x <= $x and $x < (.x + .width) and .y <= $y and $y < (.y + .height)) | .name
')

# Get monitor offsets
monitor_x_offset=$(hyprctl monitors -j | jq -r --arg name "$monitor_info" '.[] | select(.name == $name) | .x')
monitor_y_offset=$(hyprctl monitors -j | jq -r --arg name "$monitor_info" '.[] | select(.name == $name) | .y')
monitor_width=$(hyprctl monitors -j | jq -r --arg name "$monitor_info" '.[] | select(.name == $name) | .width')

# Calculate center position for calendar
popup_width=400
popup_x=$(( (monitor_width / 2) - (popup_width / 2) -20 ))
popup_y=-5

# Keep popup on screen
[[ $popup_x -lt 0 ]] && popup_x=5
[[ $popup_y -lt 0 ]] && popup_y=1

# Save position info for sub-popups
echo "$monitor_info" > /tmp/eww_calendar_monitor
echo "$popup_x" > /tmp/eww_calendar_x
echo "$popup_y" > /tmp/eww_calendar_y

if eww active-windows | grep -q "calendar_popup"; then
    eww close calendar_popup
    eww close event_details 2>/dev/null
    eww close event_editor 2>/dev/null
    eww close confirm_dialog 2>/dev/null
    eww close month_picker 2>/dev/null
    eww close year_picker 2>/dev/null
    rm /tmp/eww_event_popup_state 2>/dev/null
    ~/.config/eww/scripts/close-pickers.sh 2>/dev/null
    echo "0" > /tmp/eww_calendar_offset
else
    # Close other popups
    eww close audio_popup bluetooth_popup network_popup display_popup battery_popup system_popup workspace_popup power_popup 2>/dev/null
    echo "0" > /tmp/eww_calendar_offset
    eww open calendar_popup --screen "$monitor_info" --pos "${popup_x}x${popup_y}"
fi