#!/bin/bash
# Delete event

uid=$(eww get event_editor_uid)

if [[ -z "$uid" ]]; then
    notify-send "Event Editor" "No event to delete" -u critical
    exit 1
fi

# Find the ICS file
ics_file=$(find ~/.local/share/calendars/google/ -name "${uid}.ics" 2>/dev/null | head -1)

if [[ -f "$ics_file" ]]; then
    rm "$ics_file"
    
    notify-send "Event Editor" "Event deleted" -u normal
    
    # Sync with Google Calendar
    vdirsyncer sync &
    
    # Close editor
    ~/.config/eww/scripts/close-event-editor.sh
    
    # Refresh calendar display
    echo "0" > /tmp/eww_calendar_offset
    
    # Close event details if open
    eww close event_details 2>/dev/null
else
    notify-send "Event Editor" "Could not find event to delete" -u critical
fi