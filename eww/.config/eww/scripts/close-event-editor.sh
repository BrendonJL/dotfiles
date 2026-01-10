#!/bin/bash
# Close event editor and reset state

eww close event_editor
eww close event_details
eww close confirm_dialog 2>/dev/null
rm -f /tmp/eww_event_popup_state

# Reset dropdowns
eww update show_calendar_dropdown="false"
eww update show_month_dropdown="false"
eww update show_day_dropdown="false"
eww update show_year_dropdown="false"
eww update show_start_time_dropdown="false"
eww update show_end_time_dropdown="false"
eww update show_repeat_dropdown="false"
eww update show_alarm_dropdown="false"