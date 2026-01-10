#!/bin/bash
# Toggle year picker with dynamic positioning

monitor_info=$(cat /tmp/eww_calendar_monitor 2>/dev/null || echo "")
cal_x=$(cat /tmp/eww_calendar_x 2>/dev/null || echo "0")
cal_y=$(cat /tmp/eww_calendar_y 2>/dev/null || echo "30")

# Position year picker relative to calendar
picker_x=$((cal_x + 197))
picker_y=$((cal_y + 60))

if eww active-windows | grep -q 'year_picker'; then
    eww close year_picker
else
    eww close month_picker 2>/dev/null
    eww open year_picker --screen "$monitor_info" --pos "${picker_x}x${picker_y}"
fi