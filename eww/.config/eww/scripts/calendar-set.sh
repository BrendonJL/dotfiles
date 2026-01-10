#!/bin/bash

OFFSET_FILE="/tmp/eww_calendar_offset"
TYPE="$1"   # "month" or "year"
VALUE="$2"  # month number (1-12) or year (2020-2030)

# Get current date
current_year=$(date +%Y)
current_month=$(date +%m)

if [ "$TYPE" = "month" ]; then
    # Calculate offset from current month
    target_month=$VALUE
    target_year=$current_year
    
    # Calculate month difference
    offset=$(( (target_year - current_year) * 12 + (target_month - current_month) ))
    
elif [ "$TYPE" = "year" ]; then
    # Calculate offset from current year
    target_year=$VALUE
    offset=$(cat "$OFFSET_FILE")
    
    # Get the month from current offset
    current_offset_date=$(date -d "$(cat /tmp/eww_calendar_offset) month" '+%Y %m')
    offset_year=$(echo $current_offset_date | awk '{print $1}')
    offset_month=$(echo $current_offset_date | awk '{print $2}')
    
    # Calculate new offset maintaining the month
    offset=$(( (target_year - current_year) * 12 + (offset_month - current_month) ))
fi

# Save new offset
echo "$offset" > "$OFFSET_FILE"