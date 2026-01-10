#!/bin/bash

# Wait for Hyprland to be fully ready
sleep 3

# EasyEffects
easyeffects &
sleep 2
hyprctl dispatch movetoworkspacesilent special:eq,class:com.github.wwmm.easyeffects

# Pavucontrol
pavucontrol &
sleep 2
hyprctl dispatch movetoworkspacesilent special:audio,class:pavucontrol

# Terminal scratchpad
konsole --profile "Brendon Lasley" &
sleep 2
hyprctl dispatch movetoworkspacesilent special:term,class:konsole

# Discord
/usr/bin/Discord &
sleep 3
hyprctl dispatch movetoworkspacesilent special:discord,class:discord

# Music (BetterSoundCloud)
/home/blasley/BetterSoundCloud-Linux/start.sh &
sleep 3
hyprctl dispatch movetoworkspacesilent special:music,title:BetterSoundCloud

# Xpad (notes)
xpad &
sleep 1
hyprctl dispatch movetoworkspacesilent special:notes,class:xpad
