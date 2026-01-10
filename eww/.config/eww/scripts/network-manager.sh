#!/usr/bin/env bash

# Check if nmtui is already running
if pgrep -x "nmtui" > /dev/null; then
    # Just toggle the workspace
    hyprctl dispatch togglespecialworkspace network
else
    # Launch nmtui in konsole with tui profile
    konsole --profile tui -e nmtui &
fi