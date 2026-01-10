#!/bin/bash
# Toggle month picker with dynamic positioning

monitor_info=$(cat /tmp/eww_calendar_monitor 2>/dev/null || echo "")
cal_x=$(cat /tmp/eww_calendar_x 2>/dev/null || echo "0")
cal_y=$(cat /tmp/eww_calendar_y 2>/dev/null || echo "30")

# Position month picker relative to calendar
picker_x=$((cal_x + 100))
picker_y=$((cal_y + 35))

if eww active-windows | grep -q 'month_picker'; then
    eww close month_picker
else
    eww close year_picker 2>/dev/null
    eww open month_picker --screen "$monitor_info" --pos "${picker_x}x${picker_y}"
fi