#!/bin/bash
# Calendar waybar script with upcoming events tooltip

# Get current date/time
current_time=$(date "+%-I:%M%P")
current_date=$(date "+%a %b %d")

# Count events in next 7 days using khal
upcoming_count=0
if command -v khal &>/dev/null; then
    upcoming_count=$(khal list now 7d 2>/dev/null | grep -v "^$" | wc -l)
fi

# Build tooltip
if [[ $upcoming_count -gt 0 ]]; then
    tooltip="📅 $upcoming_count events this week"
else
    tooltip="No upcoming events"
fi

# Output JSON
jq -nc \
  --arg text "$current_time  $current_date" \
  --arg tooltip "$tooltip" \
  '{text: $text, tooltip: $tooltip, class: "calendar"}'