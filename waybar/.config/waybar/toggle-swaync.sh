#!/bin/bash
STATE_FILE="/tmp/swaync-state"

if [ -f "$STATE_FILE" ]; then
    swaync-client -cp
    rm "$STATE_FILE"
else
    swaync-client -op
    touch "$STATE_FILE"
fi