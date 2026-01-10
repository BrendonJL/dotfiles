#!/bin/bash
# ~/.config/waybar/bluetooth-toggle.sh
# Toggles bluetooth power state

powered=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')

if [[ "$powered" == "yes" ]]; then
    bluetoothctl power off
else
    bluetoothctl power on
fi