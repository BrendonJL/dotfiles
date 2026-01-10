#!/bin/bash
# ~/.config/waybar/audio-waybar.sh
# Outputs JSON for waybar with volume level, tooltip, and color class

get_volume() {
    pamixer --get-volume 2>/dev/null || echo "0"
}

get_muted() {
    pamixer --get-mute 2>/dev/null || echo "false"
}

get_now_playing() {
    # Try to get currently playing track
    if command -v playerctl &>/dev/null; then
        status=$(playerctl status 2>/dev/null)
        if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
            artist=$(playerctl metadata artist 2>/dev/null | cut -c1-20)
            title=$(playerctl metadata title 2>/dev/null | cut -c1-25)
            if [[ -n "$title" ]]; then
                if [[ -n "$artist" ]]; then
                    echo "$artist - $title"
                else
                    echo "$title"
                fi
                return
            fi
        fi
    fi
    echo "Nothing playing"
}

get_icon() {
    # Static icon - always the same
    echo "󰕾"
}

get_class() {
    local muted=$1
    local vol=$2
    
    if [[ "$muted" == "true" ]]; then
        echo "muted"
    elif [[ $vol -ge 90 ]]; then
        echo "vol-high"
    elif [[ $vol -ge 70 ]]; then
        echo "vol-warning"
    elif [[ $vol -ge 40 ]]; then
        echo "vol-mid"
    else
        echo "vol-low"
    fi
}

is_popup_open() {
    eww list-windows | grep -q '\*audio_popup' && echo "true" || echo "false"
}

vol=$(get_volume)
muted=$(get_muted)
now_playing=$(get_now_playing)
icon=$(get_icon "$muted" "$vol")
class=$(get_class "$muted" "$vol")
popup_open=$(is_popup_open)

# Build tooltip - empty if popup is open
if [[ "$popup_open" == "true" ]]; then
    tooltip=""
else
    if [[ "$muted" == "true" ]]; then
        tooltip="󰝟 Muted\n󰎈 $now_playing"
    else
        tooltip="󰕾 ${vol}%\n󰎈 $now_playing"
    fi
fi

# Output JSON for waybar
echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"