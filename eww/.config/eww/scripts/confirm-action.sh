#!/bin/bash
# Show confirmation dialog for save/cancel/delete

action="$1"

# Get monitor and position info
monitor_info=$(cat /tmp/eww_calendar_monitor 2>/dev/null || echo "")
cal_x=$(cat /tmp/eww_calendar_x 2>/dev/null || echo "0")
cal_y=$(cat /tmp/eww_calendar_y 2>/dev/null || echo "30")

# Event editor position (should match open-event-editor.sh)
editor_x=$((cal_x + 435))
editor_y=$((cal_y + 200))

# Confirm dialog dimensions (from defwindow)
dialog_width=250
dialog_height=100

# Event editor dimensions
editor_width=350

# Center the dialog over the event editor
dialog_x=$((editor_x + (editor_width - dialog_width) / 2))
dialog_y=$((editor_y + 200))  # Position it in the middle-ish of the editor

case "$action" in
    save)
        eww update confirm_message="Save this event?"
        eww update confirm_action="~/.config/eww/scripts/save-event.sh && eww close confirm_dialog"
        ;;
    cancel)
        eww update confirm_message="Discard changes?"
        eww update confirm_action="~/.config/eww/scripts/close-event-editor.sh"
        ;;
    delete)
        eww update confirm_message="Delete this event? This cannot be undone."
        eww update confirm_action="~/.config/eww/scripts/delete-event.sh && eww close confirm_dialog"
        ;;
esac

eww open confirm_dialog --screen "$monitor_info" --pos "${dialog_x}x${dialog_y}"