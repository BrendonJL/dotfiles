#!/bin/bash
# Open event editor - either new event or edit existing
# Usage: open-event-editor.sh [new|edit] [date] [uid]

mode="${1:-new}"
date="${2:-$(date +%Y-%m-%d)}"
uid="${3:-}"

# Get monitor info from calendar popup
monitor_info=$(cat /tmp/eww_calendar_monitor 2>/dev/null || echo "")
cal_x=$(cat /tmp/eww_calendar_x 2>/dev/null || echo "0")
cal_y=$(cat /tmp/eww_calendar_y 2>/dev/null || echo "30")

# Position editor to the right of calendar, below event details
editor_x=$((cal_x + 435))
editor_y=$((cal_y + 220))

# Calculate current time rounded to next 15 minutes
current_hour=$(date +%H)
current_min=$(date +%M)
rounded_min=$(( (current_min / 15 + 1) * 15 ))

if [ $rounded_min -eq 60 ]; then
    start_hour=$((current_hour + 1))
    start_min="00"
else
    start_hour=$current_hour
    start_min=$(printf "%02d" $rounded_min)
fi

# Convert to 12-hour format with AM/PM
if [ $start_hour -eq 0 ]; then
    start_12=$((12))
    start_ampm="AM"
elif [ $start_hour -lt 12 ]; then
    start_12=$start_hour
    start_ampm="AM"
elif [ $start_hour -eq 12 ]; then
    start_12=12
    start_ampm="PM"
else
    start_12=$((start_hour - 12))
    start_ampm="PM"
fi

# End time is 1 hour after start
end_hour=$((start_hour + 1))
if [ $end_hour -eq 0 ]; then
    end_12=12
    end_ampm="AM"
elif [ $end_hour -lt 12 ]; then
    end_12=$end_hour
    end_ampm="AM"
elif [ $end_hour -eq 12 ]; then
    end_12=12
    end_ampm="PM"
else
    end_12=$((end_hour - 12))
    end_ampm="PM"
fi

start_time="${start_12}:${start_min} ${start_ampm}"
end_time="${end_12}:${start_min} ${end_ampm}"

# Parse date into components
date_month=$(date -d "$date" +%B)  # Full month name
date_day=$(date -d "$date" +%-d)   # Day without leading zero
date_year=$(date -d "$date" +%Y)   # Year

# Reset all fields
eww update event_editor_mode="$mode"
eww update event_editor_uid="$uid"
eww update event_editor_month="$date_month"
eww update event_editor_day="$date_day"
eww update event_editor_year="$date_year"
eww update event_editor_title=""
eww update event_editor_calendar="brendon"
eww update event_editor_start_time="$start_time"
eww update event_editor_end_time="$end_time"
eww update event_editor_all_day="false"
eww update event_editor_location=""
eww update event_editor_description=""
eww update event_editor_repeat="none"
eww update event_editor_repeat_until=""
eww update event_editor_alarm=""
eww update event_editor_url=""
eww update event_editor_categories=""

# Close all dropdowns
eww update show_calendar_dropdown="false"
eww update show_month_dropdown="false"
eww update show_day_dropdown="false"
eww update show_year_dropdown="false"
eww update show_start_time_dropdown="false"
eww update show_end_time_dropdown="false"
eww update show_repeat_dropdown="false"
eww update show_alarm_dropdown="false"

# If editing, load event data
if [[ "$mode" == "edit" && -n "$uid" ]]; then
    # Find the ICS file
    ics_file=$(find ~/.local/share/calendars/google/ -name "${uid}.ics" 2>/dev/null | head -1)
    
    if [[ -f "$ics_file" ]]; then
        # Parse ICS file
        title=$(grep "^SUMMARY:" "$ics_file" | head -1 | sed 's/SUMMARY://' | tr -d '\r')
        location=$(grep "^LOCATION:" "$ics_file" | head -1 | sed 's/LOCATION://' | tr -d '\r')
        description=$(grep "^DESCRIPTION:" "$ics_file" | head -1 | sed 's/DESCRIPTION://' | tr -d '\r' | sed 's/\\n/ /g')
        
        # Get start/end times
        dtstart=$(grep "^DTSTART" "$ics_file" | head -1 | sed 's/.*://' | tr -d '\r')
        dtend=$(grep "^DTEND" "$ics_file" | head -1 | sed 's/.*://' | tr -d '\r')
        
        # Check if all-day event (date only, no time)
        if [[ ${#dtstart} -eq 8 ]]; then
            eww update event_editor_all_day="true"
            event_date="${dtstart:0:4}-${dtstart:4:2}-${dtstart:6:2}"
            date_month=$(date -d "$event_date" +%B)
            date_day=$(date -d "$event_date" +%-d)
            date_year=$(date -d "$event_date" +%Y)
            eww update event_editor_month="$date_month"
            eww update event_editor_day="$date_day"
            eww update event_editor_year="$date_year"
        else
            eww update event_editor_all_day="false"
            event_date="${dtstart:0:4}-${dtstart:4:2}-${dtstart:6:2}"
            start_time="${dtstart:9:2}:${dtstart:11:2}"
            end_time="${dtend:9:2}:${dtend:11:2}"
            date_month=$(date -d "$event_date" +%B)
            date_day=$(date -d "$event_date" +%-d)
            date_year=$(date -d "$event_date" +%Y)
            eww update event_editor_month="$date_month"
            eww update event_editor_day="$date_day"
            eww update event_editor_year="$date_year"
            eww update event_editor_start_time="$start_time"
            eww update event_editor_end_time="$end_time"
        fi
        
        # Determine which calendar
        if [[ "$ics_file" == *"lasleybrendon"* ]]; then
            eww update event_editor_calendar="lasleybrendon"
        elif [[ "$ics_file" == *"family"* ]]; then
            eww update event_editor_calendar="family"
        elif [[ "$ics_file" == *"fqs3fn"* ]]; then
            eww update event_editor_calendar="brendon"
        fi
        
        eww update event_editor_title="$title"
        eww update event_editor_location="$location"
        eww update event_editor_description="$description"
        eww update event_editor_uid="$uid"
    fi
fi

# Open the editor
eww open event_editor --screen "$monitor_info" --pos "${editor_x}x${editor_y}"