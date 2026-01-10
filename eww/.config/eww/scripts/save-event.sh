#!/bin/bash
# Save event using khal

# Get values from eww
mode=$(eww get event_editor_mode)
uid=$(eww get event_editor_uid)
title=$(eww get event_editor_title)
calendar=$(eww get event_editor_calendar)

# Map display names to actual khal calendar names
case "$calendar" in
    brendon)
        calendar="lasleybrendon@gmail.com"
        ;;
    birthdays)
        calendar="cln2stbjc4hmgrrcd5i62ua0ctp6utbg5pr2sor1dhimsp31e8n6errfctm6abj3dtmg@virtual"
        ;;
    family)
        calendar="family16814563994359017180@group.calendar.google.com"
        ;;
esac

# Reconstruct date from components
month=$(eww get event_editor_month)
day=$(eww get event_editor_day)
year=$(eww get event_editor_year)

# Convert month name to number
case "$month" in
    January) month_num="01" ;;
    February) month_num="02" ;;
    March) month_num="03" ;;
    April) month_num="04" ;;
    May) month_num="05" ;;
    June) month_num="06" ;;
    July) month_num="07" ;;
    August) month_num="08" ;;
    September) month_num="09" ;;
    October) month_num="10" ;;
    November) month_num="11" ;;
    December) month_num="12" ;;
esac

# Format date as YYYY-MM-DD
date=$(printf "%s-%s-%02d" "$year" "$month_num" "$day")

start_time=$(eww get event_editor_start_time)
end_time=$(eww get event_editor_end_time)

# Convert 12-hour format to 24-hour for khal
if [[ "$start_time" =~ ([0-9]+):([0-9]+)\ (AM|PM) ]]; then
    hour=${BASH_REMATCH[1]}
    min=${BASH_REMATCH[2]}
    ampm=${BASH_REMATCH[3]}
    
    if [[ "$ampm" == "PM" && "$hour" != "12" ]]; then
        hour=$((hour + 12))
    elif [[ "$ampm" == "AM" && "$hour" == "12" ]]; then
        hour=0
    fi
    start_time=$(printf "%02d:%s" "$hour" "$min")
fi

if [[ "$end_time" =~ ([0-9]+):([0-9]+)\ (AM|PM) ]]; then
    hour=${BASH_REMATCH[1]}
    min=${BASH_REMATCH[2]}
    ampm=${BASH_REMATCH[3]}
    
    if [[ "$ampm" == "PM" && "$hour" != "12" ]]; then
        hour=$((hour + 12))
    elif [[ "$ampm" == "AM" && "$hour" == "12" ]]; then
        hour=0
    fi
    end_time=$(printf "%02d:%s" "$hour" "$min")
fi

all_day=$(eww get event_editor_all_day)
location=$(eww get event_editor_location)
description=$(eww get event_editor_description)
repeat=$(eww get event_editor_repeat)
repeat_until=$(eww get event_editor_repeat_until)
alarm=$(eww get event_editor_alarm)
categories=$(eww get event_editor_categories)
url=$(eww get event_editor_url)

# Validate required fields
if [[ -z "$title" ]]; then
    notify-send "Event Editor" "Title is required" -u critical
    exit 1
fi

if [[ -z "$date" ]]; then
    notify-send "Event Editor" "Date is required" -u critical
    exit 1
fi

# Build khal command
cmd="khal new -a $calendar"

# Add location if provided
if [[ -n "$location" ]]; then
    cmd="$cmd -l \"$location\""
fi

# Add categories if provided
if [[ -n "$categories" ]]; then
    cmd="$cmd -g \"$categories\""
fi

# Add repeat if set
if [[ "$repeat" != "none" ]]; then
    cmd="$cmd -r $repeat"
    if [[ -n "$repeat_until" ]]; then
        cmd="$cmd -u $repeat_until"
    fi
fi

# Add alarm if set
if [[ -n "$alarm" ]]; then
    cmd="$cmd -m $alarm"
fi

# Add URL if provided
if [[ -n "$url" ]]; then
    cmd="$cmd --url \"$url\""
fi

# Build date/time string
if [[ "$all_day" == "true" ]]; then
    datetime="$date"
else
    datetime="$date $start_time $date $end_time"
fi

# Add title and description
if [[ -n "$description" ]]; then
    cmd="$cmd $datetime \"$title\" :: \"$description\""
else
    cmd="$cmd $datetime \"$title\""
fi

# If editing, delete old event first
if [[ "$mode" == "edit" && -n "$uid" ]]; then
    # Find and delete the old ICS file
    ics_file=$(find ~/.local/share/calendars/google/ -name "${uid}.ics" 2>/dev/null | head -1)
    if [[ -f "$ics_file" ]]; then
        rm "$ics_file"
    fi
fi

## Execute khal command
echo "Executing: $cmd" > /tmp/khal-debug.log
eval $cmd 2>&1 | tee -a /tmp/khal-debug.log
khal_exit=$?

if [[ $khal_exit -eq 0 ]]; then
    notify-send "Event Editor" "Event saved successfully" -u normal
    
    # Close editor first
    ~/.config/eww/scripts/close-event-editor.sh
    
    # Sync with Google Calendar using a lock file
    (
        # Wait a bit then sync if not already syncing
        sleep 2
        lockfile="/tmp/vdirsyncer.lock"
        if [ ! -f "$lockfile" ]; then
            touch "$lockfile"
            vdirsyncer sync > /dev/null 2>&1
            rm "$lockfile"
        fi
    ) &
    
    # Refresh calendar display
    echo "0" > /tmp/eww_calendar_offset
else
    notify-send "Event Editor" "Failed to save event" -u critical
    cat /tmp/khal-debug.log
fi