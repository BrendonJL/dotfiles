#!/bin/bash

OFFSET_FILE="/tmp/eww_calendar_offset"

# Initialize if doesn't exist
[ ! -f "$OFFSET_FILE" ] && echo "0" > "$OFFSET_FILE"

# Read current offset
current=$(cat "$OFFSET_FILE")

# Update based on action
case "$1" in
    "prev") new=$((current - 1)) ;;
    "next") new=$((current + 1)) ;;
    "reset") new=0 ;;
    *) new=$current ;;
esac

# Save new offset
echo "$new" > "$OFFSET_FILE"

# Trigger update by sending signal
pkill -RTMIN+1 calendar-listener