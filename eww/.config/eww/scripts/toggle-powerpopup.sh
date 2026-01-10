#!/bin/bash
# Toggle power popup with cursor-relative positioning

cursor_info=$(hyprctl cursorpos -j)
X=$(echo "$cursor_info" | jq -r '.x')
Y=$(echo "$cursor_info" | jq -r '.y')

monitor_info=$(hyprctl monitors -j | jq -r --argjson x "$X" --argjson y "$Y" '
    .[] | select(.x <= $x and $x < (.x + .width) and .y <= $y and $y < (.y + .height)) | .name
')

monitor_x_offset=$(hyprctl monitors -j | jq -r --arg name "$monitor_info" '.[] | select(.name == $name) | .x')

popup_x=$((X - monitor_x_offset - 53))
popup_y=-5

[[ $popup_y -lt 0 ]] && popup_y=1

if eww active-windows | grep -q 'power_popup'; then
    eww close power_popup
else
    eww close audio_popup bluetooth_popup network_popup display_popup battery_popup system_popup calendar_popup workspace_popup month_picker year_picker event_details event_editor confirm_dialog 2>/dev/null
    eww open power_popup --screen "$monitor_info" --pos "${popup_x}x${popup_y}"
fi