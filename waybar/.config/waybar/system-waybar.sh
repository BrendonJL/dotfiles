#!/bin/bash
# ~/.config/waybar/system-waybar.sh
# Outputs JSON for waybar with system load color and quick stats tooltip

get_cpu_usage() {
    # Get CPU usage percentage
    top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}'
}

get_memory_usage() {
    # Get memory usage percentage
    free | grep Mem | awk '{print int($3/$2 * 100)}'
}

get_class() {
    local cpu=$1
    local mem=$2
    
    # Use the higher of CPU or memory for color
    local max=$cpu
    [[ $mem -gt $max ]] && max=$mem
    
    if [[ $max -ge 90 ]]; then
        echo "sys-critical"
    elif [[ $max -ge 70 ]]; then
        echo "sys-high"
    elif [[ $max -ge 50 ]]; then
        echo "sys-mid"
    elif [[ $max -ge 30 ]]; then
        echo "sys-low"
    else
        echo "sys-idle"
    fi
}

cpu=$(get_cpu_usage)
mem=$(get_memory_usage)
class=$(get_class "$cpu" "$mem")
icon="󰒓"

# Build tooltip
tooltip="󰻠 CPU: ${cpu}%  󰍛 RAM: ${mem}%"

# Output JSON for waybar
echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"