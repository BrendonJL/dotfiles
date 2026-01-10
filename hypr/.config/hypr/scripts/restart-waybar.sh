#!/bin/bash

# Kill all waybar instances
killall waybar

# Wait a moment for processes to fully terminate
sleep 0.5

# Restart all three waybars
waybar -c ~/.config/waybar/config &
waybar -c ~/.config/waybar/config-right &
waybar -c ~/.config/waybar/config-laptop &
