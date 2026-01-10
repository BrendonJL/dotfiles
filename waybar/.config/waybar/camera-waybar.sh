#!/bin/bash
# Check if camera is being used (ignore Discord)

cam_pids=$(fuser /dev/video* 2>/dev/null | tr -s ' ' '\n' | grep -v '^$')

if [[ -n "$cam_pids" ]]; then
    # Get app names from PIDs, excluding Discord
    cam_apps=""
    for pid in $cam_pids; do
        app_name=$(ps -p "$pid" -o comm= 2>/dev/null)
        if [[ -n "$app_name" && "$app_name" != "Discord" && "$app_name" != "discord" ]]; then
            cam_apps+="$app_name, "
        fi
    done
    cam_apps=$(echo "$cam_apps" | sed 's/, $//')
    
    if [[ -n "$cam_apps" ]]; then
        echo "{\"text\": \"󰄀\", \"tooltip\": \"Camera: $cam_apps\", \"class\": \"cam-active\"}"
    else
        echo "{\"text\": \"󰄁\", \"tooltip\": \"Camera inactive\", \"class\": \"cam-inactive\"}"
    fi
else
    echo "{\"text\": \"󰄁\", \"tooltip\": \"Camera inactive\", \"class\": \"cam-inactive\"}"
fi