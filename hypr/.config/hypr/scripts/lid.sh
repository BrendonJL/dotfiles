#!/usr/bin/env bash

LID_STATE=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}')

if [ "$LID_STATE" = "closed" ]; then
    # turn off laptop screen
    hyprctl keyword monitor "eDP-1, disable"
else
    # re-enable laptop screen
    hyprctl keyword monitor "eDP-1, preferred, auto, 1"
fi
