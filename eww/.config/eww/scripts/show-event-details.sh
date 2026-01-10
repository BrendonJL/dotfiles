#!/bin/bash

day=$1
state_file="/tmp/eww_event_popup_state"

# Get saved calendar position info
monitor_info=$(cat /tmp/eww_calendar_monitor 2>/dev/null || echo "")
cal_x=$(cat /tmp/eww_calendar_x 2>/dev/null || echo "0")
cal_y=$(cat /tmp/eww_calendar_y 2>/dev/null || echo "30")

# Position event details to the right of calendar
details_x=$((cal_x + 435))
details_y=$((cal_y + 0))

# Close event editor if it's open (when clicking calendar)
eww close event_editor 2>/dev/null
eww close confirm_dialog 2>/dev/null

# Check if showing the same day
current_day=$(cat "$state_file" 2>/dev/null || echo "")

if [ "$current_day" = "$day" ]; then
    # Same day clicked - toggle close
    eww close event_details
    rm -f "$state_file"
else
    # Different day - update and open
    ~/.config/eww/scripts/get-day-events.sh "$day" > /tmp/eww_event_details
    echo "$day" > "$state_file"
    eww close event_details 2>/dev/null  # Close if already open
    eww open event_details --screen "$monitor_info" --pos "${details_x}x${details_y}"
fi