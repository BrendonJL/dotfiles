#!/bin/bash
# Open date picker for event editor

# Get current event editor date or use today
current_date=$(eww get event_editor_date 2>/dev/null || date +%Y-%m-%d)

# Parse the date
year=$(echo "$current_date" | cut -d'-' -f1)
month=$(echo "$current_date" | cut -d'-' -f2)

# Set calendar to show the correct month/year
~/.config/eww/scripts/calendar-set.sh month "$((10#$month))"
~/.config/eww/scripts/calendar-set.sh year "$year"

# Get monitor and position info
monitor_info=$(cat /tmp/eww_calendar_monitor 2>/dev/null || echo "")
cal_x=$(cat /tmp/eww_calendar_x 2>/dev/null || echo "0")
cal_y=$(cat /tmp/eww_calendar_y 2>/dev/null || echo "30")

# Position date picker (event editor position)
editor_x=$((cal_x + 435))
editor_y=$((cal_y + 160))

# Position picker below the date field (roughly 100px down)
picker_x=$((editor_x))
picker_y=$((editor_y + 100))

# Store that we're in date picker mode for event editor
echo "event_editor" > /tmp/eww_date_picker_mode

# Open date picker in picker mode
eww open date_picker --screen "$monitor_info" --pos "${picker_x}x${picker_y}"