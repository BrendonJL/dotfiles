#!/bin/bash
# ~/.config/waybar/battery-waybar.sh
# Outputs JSON for waybar with battery percentage, charging status, and color class

get_battery_info() {
    # Get battery percentage and status
    if [[ -f /sys/class/power_supply/BAT0/capacity ]]; then
        capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
        status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
    elif [[ -f /sys/class/power_supply/BAT1/capacity ]]; then
        capacity=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)
        status=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null)
    else
        # Try upower as fallback
        capacity=$(upower -i $(upower -e | grep BAT) 2>/dev/null | grep percentage | awk '{print $2}' | tr -d '%')
        status=$(upower -i $(upower -e | grep BAT) 2>/dev/null | grep state | awk '{print $2}')
    fi
    
    # Default values if not found
    capacity=${capacity:-100}
    status=${status:-Unknown}
    
    echo "$capacity|$status"
}

get_icon() {
    local status=$1
    local capacity=$2
    
    # Charging icons
    if [[ "$status" == "Charging" || "$status" == "charging" ]]; then
        echo "󰂄"  # charging icon
    elif [[ "$status" == "Full" || "$status" == "full" ]]; then
        echo "󰁹"  # full icon
    else
        # Discharging - icon based on level
        if [[ $capacity -ge 90 ]]; then
            echo "󰁹"
        elif [[ $capacity -ge 80 ]]; then
            echo "󰂂"
        elif [[ $capacity -ge 70 ]]; then
            echo "󰂁"
        elif [[ $capacity -ge 60 ]]; then
            echo "󰂀"
        elif [[ $capacity -ge 50 ]]; then
            echo "󰁿"
        elif [[ $capacity -ge 40 ]]; then
            echo "󰁾"
        elif [[ $capacity -ge 30 ]]; then
            echo "󰁽"
        elif [[ $capacity -ge 20 ]]; then
            echo "󰁼"
        elif [[ $capacity -ge 10 ]]; then
            echo "󰁻"
        else
            echo "󰁺"
        fi
    fi
}

get_class() {
    local capacity=$1
    
    if [[ $capacity -ge 80 ]]; then
        echo "bat-full"
    elif [[ $capacity -ge 60 ]]; then
        echo "bat-good"
    elif [[ $capacity -ge 40 ]]; then
        echo "bat-mid"
    elif [[ $capacity -ge 20 ]]; then
        echo "bat-low"
    else
        echo "bat-critical"
    fi
}

# Parse battery info
IFS='|' read -r capacity status <<< "$(get_battery_info)"

icon=$(get_icon "$status" "$capacity")
class=$(get_class "$capacity")

# Build tooltip
if [[ "$status" == "Charging" || "$status" == "charging" ]]; then
    tooltip="󰂄 ${capacity}% (Charging)"
elif [[ "$status" == "Full" || "$status" == "full" ]]; then
    tooltip="󰁹 ${capacity}% (Full)"
elif [[ "$status" == "Discharging" || "$status" == "discharging" ]]; then
    tooltip="󰁹 ${capacity}% (Discharging)"
else
    tooltip="󰁹 ${capacity}% ($status)"
fi

# Output JSON for waybar
echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"