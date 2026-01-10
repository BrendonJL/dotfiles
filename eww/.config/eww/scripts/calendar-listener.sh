#!/bin/bash

OFFSET_FILE="/tmp/eww_calendar_offset"
MODE="$1"

# Initialize
[ ! -f "$OFFSET_FILE" ] && echo "0" > "$OFFSET_FILE"

offset=$(cat "$OFFSET_FILE")

case "$MODE" in
    "month")
        # Output just the month name
        if [ "$offset" -eq 0 ]; then
            date '+%B'
        else
            date -d "$offset month" '+%B'
        fi
        ;;
    "year")
        # Output just the year
        if [ "$offset" -eq 0 ]; then
            date '+%Y'
        else
            date -d "$offset month" '+%Y'
        fi
        ;;
    "header")
        # Output month and year together (kept for compatibility)
        if [ "$offset" -eq 0 ]; then
            date '+%B %Y'
        else
            date -d "$offset month" '+%B %Y'
        fi
        ;;
    "days")
        # Output calendar days
        ~/.config/eww/scripts/render-clockpopup.sh "$offset"
        ;;
esac