#!/bin/bash
# ~/.config/waybar/network-toggle.sh
# Toggles wifi on/off

wifi_status=$(nmcli radio wifi 2>/dev/null)

if [[ "$wifi_status" == "enabled" ]]; then
    nmcli radio wifi off
else
    nmcli radio wifi on
fi