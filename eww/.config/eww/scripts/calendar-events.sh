#!/bin/bash

# Get events for current month + next month
year=$(cat ~/.config/eww/calendar-state.txt 2>/dev/null | jq -r '.year // empty')
month=$(cat ~/.config/eww/calendar-state.txt 2>/dev/null | jq -r '.month // empty')

# If no state file, use current date
if [ -z "$year" ] || [ -z "$month" ]; then
    year=$(date +%Y)
    month=$(date +%m)
fi

# Get first and last day of the month
first_day="${year}-${month}-01"
last_day=$(date -d "${first_day} +1 month -1 day" +%Y-%m-%d)

# Get events for this date range
events=$(khal list "$first_day" "$last_day" 2>/dev/null)

if [ -z "$events" ]; then
    echo '{}'
    exit 0
fi

# Parse into JSON organized by day
echo '{'

first=true
current_date=""
declare -A date_events

while IFS= read -r line; do
    # Check if it's a date line
    if [[ $line =~ ^[A-Za-z]+,\ ([0-9]{4}-[0-9]{2}-[0-9]{2})$ ]]; then
        current_date="${BASH_REMATCH[1]}"
        # Extract just the day number
        day=$(echo "$current_date" | cut -d'-' -f3)
        # Remove leading zero
        day=$((10#$day))
    # Event line
    elif [[ -n "$line" && -n "$current_date" ]]; then
        # Extract time and title
        if [[ $line =~ ^([0-9]{2}:[0-9]{2}-[0-9]{2}:[0-9]{2})\ (.+)$ ]]; then
            time="${BASH_REMATCH[1]}"
            title="${BASH_REMATCH[2]}"
        else
            time="All day"
            title="$line"
        fi
        
        # Clean up title
        title=$(echo "$title" | sed 's/ ⏰ ::.*//' | sed 's/"/\\"/g')
        
        # Add comma if not first
        [ "$first" = false ] && echo ","
        first=false
        
        # Output: "day": {"time": "...", "title": "..."}
        echo -n "  \"$day\": {\"time\": \"$time\", \"title\": \"$title