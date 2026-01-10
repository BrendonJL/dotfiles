#!/bin/bash

# Get month offset from argument (default 0 = current month)
month_offset=${1:-0}
year_offset=${2:-0}

# Calculate target date
if [ "$month_offset" -eq 0 ] && [ "$year_offset" -eq 0 ]; then
    target_date=$(date)
else
    target_date=$(date -d "$month_offset month $year_offset year")
fi

# Get month info for target date
year=$(date -d "$target_date" +%Y)
month=$(date -d "$target_date" +%m)
today=$(date +%d)
current_month=$(date +%m)
current_year=$(date +%Y)

first_day=$(date -d "$year-$month-01" +%u)
days_in_month=$(date -d "$year-$month-01 +1 month -1 day" +%d)

# Adjust for Sunday start
if [ "$first_day" -eq 7 ]; then
    first_day=0
fi

# Get events for this month
first_date="${year}-${month}-01"
last_date=$(date -d "${first_date} +1 month -1 day" +%Y-%m-%d)
events=$(khal list "$first_date" "$last_date" 2>/dev/null)

# Parse which days have events
declare -A has_event
current_parse_day=""

while IFS= read -r line; do
    # Check if it's a date line
    if [[ $line =~ ^[A-Za-z]+,\ [0-9]{4}-[0-9]{2}-([0-9]{2})$ ]]; then
        current_parse_day="${BASH_REMATCH[1]}"
        # Remove leading zero
        current_parse_day=$((10#$current_parse_day))
        has_event[$current_parse_day]=1
    fi
done <<< "$events"

# Generate calendar
echo '(box :class "calendar-days" :orientation "v"'

day=1
for week in {1..6}; do
    echo '  (box :class "week-row" :orientation "h"'
    
    for dow in {0..6}; do
        if [ $week -eq 1 ] && [ $dow -lt $first_day ]; then
            echo '    (label :class "day empty" :text "")'
        elif [ $day -le $days_in_month ]; then
            # Build class string
            class="day"
            
            # Check if this is today
            if [ $day -eq $today ] && [ "$month" = "$current_month" ] && [ "$year" = "$current_year" ]; then
                class="$class today"
            fi
            
            # Check if this day has events
            if [ "${has_event[$day]}" = "1" ]; then
                class="$class has-event"
            fi
            
            # Create box with day number and event indicator
            if [ "${has_event[$day]}" = "1" ]; then
                echo "    (eventbox :class \"day-eventbox\" :onclick \"~/.config/eww/scripts/handle-day-click.sh $day > /dev/null 2>&1 &\""
                echo "      (box :class \"$class\" :orientation \"v\" :space-evenly false"
                echo "        (label :class \"day-number\" :text \"$day\")"
                echo "        (label :class \"event-dot\" :text \"●\")))"
            else
                echo "    (eventbox :class \"$class\" :onclick \"~/.config/eww/scripts/handle-day-click.sh $day > /dev/null 2>&1 &\""
                echo "      (label :text \"$day\"))"
            fi
            
            ((day++))
        else
            echo '    (label :class "day empty" :text "")'
        fi
    done
    
    echo '  )'
    
    [ $day -gt $days_in_month ] && break
done

echo ')'