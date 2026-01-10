#!/bin/bash

# Get bluetooth power state
bt_power=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
if [ "$bt_power" = "yes" ]; then
    eww update bt_powered="true"
else
    eww update bt_powered="false"
fi

# Get discoverable state
bt_disc=$(bluetoothctl show 2>/dev/null | grep "Discoverable:" | awk '{print $2}')
if [ "$bt_disc" = "yes" ]; then
    eww update bt_discoverable="true"
else
    eww update bt_discoverable="false"
fi

# Get scanning state
bt_scan=$(bluetoothctl show 2>/dev/null | grep "Discovering:" | awk '{print $2}')
if [ "$bt_scan" = "yes" ]; then
    eww update bt_scanning="true"
else
    eww update bt_scanning="false"
fi

# Get connected devices
connected_devices=$(bluetoothctl devices Connected 2>/dev/null | cut -d ' ' -f 3- | head -3 | tr '\n' ', ' | sed 's/,$//' | sed 's/,/, /g')
if [ -z "$connected_devices" ]; then
    connected_devices="None"
fi
eww update bt_connected="$connected_devices"

# Get paired devices for the list
# Format: "MAC|Name" for each device, separated by newlines
paired_json=$(bluetoothctl devices Paired 2>/dev/null | while read -r _ mac name; do
    # Check if this device is connected
    if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
        status="connected"
    else
        status="paired"
    fi
    echo "{\"mac\":\"$mac\",\"name\":\"$name\",\"status\":\"$status\"}"
done | jq -s '.' 2>/dev/null || echo "[]")

eww update bt_devices="$paired_json"