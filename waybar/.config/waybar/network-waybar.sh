#!/bin/bash
# ~/.config/waybar/network-waybar.sh
# Outputs JSON for waybar with network state, signal strength color, and connection tooltip

get_network_info() {
  # Check ethernet first (enp4s0)
  if ip link show enp4s0 2>/dev/null | grep -q "state UP"; then
    local ip=$(ip -4 addr show enp4s0 2>/dev/null | grep inet | awk '{print $2}' | cut -d/ -f1)
    echo "ethernet|100|Ethernet|$ip"
    return
  fi

  # Check if wifi is enabled
  wifi_status=$(nmcli radio wifi 2>/dev/null)

  if [[ "$wifi_status" != "enabled" ]]; then
    echo "off|0||"
    return
  fi

  # Get connected wifi info
  connection=$(nmcli -t -f active,ssid,signal dev wifi 2>/dev/null | grep "^yes" | head -1)

  if [[ -z "$connection" ]]; then
    echo "disconnected|0||"
    return
  fi

  ssid=$(echo "$connection" | cut -d: -f2)
  signal=$(echo "$connection" | cut -d: -f3)
  local ip=$(ip -4 addr show 2>/dev/null | grep inet | grep -v 127 | head -1 | awk '{print $2}' | cut -d/ -f1)

  echo "wifi|$signal|$ssid|$ip"
}

get_class() {
  local state=$1
  local signal=$2

  if [[ "$state" == "off" ]]; then
    echo "net-off"
  elif [[ "$state" == "disconnected" ]]; then
    echo "net-disconnected"
  elif [[ "$state" == "ethernet" ]]; then
    echo "net-ethernet"
  elif [[ $signal -ge 75 ]]; then
    echo "net-strong"
  elif [[ $signal -ge 50 ]]; then
    echo "net-good"
  elif [[ $signal -ge 25 ]]; then
    echo "net-weak"
  else
    echo "net-poor"
  fi
}

# Parse network info
IFS='|' read -r state signal name ip <<<"$(get_network_info)"
class=$(get_class "$state" "$signal")

# Set icon based on connection type
if [[ "$state" == "ethernet" ]]; then
  icon="󰈀"
elif [[ "$state" == "wifi" ]]; then
  icon="󰤨"
elif [[ "$state" == "disconnected" ]]; then
  icon="󰤭"
else
  icon="󰤮"
fi

# Build tooltip
if [[ "$state" == "ethernet" ]]; then
  tooltip="󰈀 Ethernet Connected\nIP: $ip"
elif [[ "$state" == "wifi" ]]; then
  tooltip="󰤨 $name (${signal}%)\nIP: $ip"
elif [[ "$state" == "disconnected" ]]; then
  tooltip="󰤭 Not connected"
else
  tooltip="󰤮 WiFi off"
fi

# Output JSON for waybar
echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"

