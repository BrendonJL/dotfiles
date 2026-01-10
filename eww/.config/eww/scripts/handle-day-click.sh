#!/bin/bash
# Handle clicking a day - either show events or set date in picker mode

day="$1"

# Get current calendar view
year=$(~/.config/eww/scripts/calendar-listener.sh year)
month=$(date -d "$(~/.config/eww/scripts/calendar-listener.sh month) 1" +%m)
formatted_day=$(printf "%02d" "$day")
selected_date="${year}-${month}-${formatted_day}"

# Check if we're in date picker mode
if [ -f /tmp/eww_date_picker_mode ]; then
    mode=$(cat /tmp/eww_date_picker_mode)
    
    if [ "$mode" = "event_editor" ]; then
        # Update event editor date
        eww update event_editor_date="$selected_date"
        
    
        eww close date_picker        
        # Clear picker mode
        rm /tmp/eww_date_picker_mode
    fi
else
    # Normal mode - show event details
    ~/.config/eww/scripts/show-event-details.sh "$day"
fi