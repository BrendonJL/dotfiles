#!/bin/bash
# Check if mic is being used (ignore cava and pavucontrol)

mic_apps=$(pactl list source-outputs 2>/dev/null | grep "application.name" | grep -v "cava" | grep -v "pavucontrol" | grep -v "PulseAudio" | cut -d'"' -f2 | tr '\n' ', ' | sed 's/,$//')

if [[ -n "$mic_apps" ]]; then
    echo "{\"text\": \"󰍬\", \"tooltip\": \"Mic: $mic_apps\", \"class\": \"mic-active\"}"
else
    echo "{\"text\": \"󰍭\", \"tooltip\": \"Mic inactive\", \"class\": \"mic-inactive\"}"
fi