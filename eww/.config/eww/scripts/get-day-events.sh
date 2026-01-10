#!/bin/bash

# Get the day number from argument
day=$1

# Get current calendar offset
offset=$(cat /tmp/eww_calendar_offset 2>/dev/null || echo 0)

# Calculate year and month based on offset
if [ "$offset" -eq 0 ]; then
    year=$(date +%Y)
    month=$(date +%m)
else
    year=$(date -d "$offset month" +%Y)
    month=$(date -d "$offset month" +%m)
fi

# Pad day to 2 digits
day_padded=$(printf "%02d" $day)
target_date="${year}-${month}-${day_padded}"
# Create display date (Month Day Year)
display_date=$(date -d "$target_date" "+%B %d, %Y")

# Get events for this specific day with UID
events=$(khal list "$target_date" "$target_date" -f "{start-time}|{end-time}|{title}|{uid}" 2>/dev/null)

if [ -z "$events" ]; then
    echo '{"day": "'$day'", "date": "'"$display_date"'", "events": [{"time": "No Events", "title": "No Events Scheduled", "uid": ""}]}'
    exit 0
fi

echo '{"day": "'$day'", "date": "'"$display_date"'", "events": ['

first=true
skip_first_line=true

while IFS= read -r line; do
    # Skip the date header line (doesn't contain |)
    if [[ ! "$line" =~ \| ]]; then
        continue
    fi
    
    # Parse the formatted output
    IFS='|' read -r start_time end_time title uid <<< "$line"
    
    # Determine time display
    if [[ -z "$start_time" || "$start_time" == "" ]]; then
        time="All day"
    else
        # Convert 24hr to 12hr format
        start_12=$(date -d "$start_time" "+%-I:%M%P" 2>/dev/null || echo "$start_time")
        end_12=$(date -d "$end_time" "+%-I:%M%P" 2>/dev/null || echo "$end_time")
        time="${start_12}-${end_12}"
    fi
    
    # Clean up title and uid
    title=$(echo "$title" | sed 's/ ⏰ ::.*//' | sed 's/"/\\"/g' | tr -d '\r')
    uid=$(echo "$uid" | tr -d '\r' | sed 's/@google.com//')
    
    [ "$first" = false ] && echo ","
    first=false
    
    echo -n "  {\"time\": \"$time\", \"title\": \"$title\", \"uid\": \"$uid\"}"
    
done <<< "$events"

echo ''
echo ']}'