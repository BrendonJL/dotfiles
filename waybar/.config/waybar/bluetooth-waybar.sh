#!/bin/bash
# ~/.config/waybar/bluetooth-waybar.sh
# Outputs JSON for waybar with bluetooth state and color class

get_bluetooth_state() {
    # Check if bluetooth is powered on
    powered=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
    
    if [[ "$powered" != "yes" ]]; then
        echo "off"
        return
    fi
    
    # Check if any device is connected
    connected=$(bluetoothctl devices Connected 2>/dev/null | head -1)
    
    if [[ -n "$connected" ]]; then
        echo "connected"
    else
        echo "on"
    fi
}

get_class() {
    local state=$1
    
    case "$state" in
        "connected") echo "bt-connected" ;;
        "on") echo "bt-on" ;;
        "off") echo "bt-off" ;;
    esac
}

state=$(get_bluetooth_state)
class=$(get_class "$state")
icon="󰂯"

# Output JSON for waybar
echo "{\"text\": \"$icon\", \"tooltip\": \"\", \"class\": \"$class\"}"