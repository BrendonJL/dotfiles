#!/usr/bin/env bash
# ~/.config/waybar/workspace-waybar.sh

MONITOR="${1:-}"

get_current_workspace() {
    if [[ -n "$MONITOR" ]]; then
        hyprctl monitors -j \
          | jq -r --arg mon "$MONITOR" \
            '.[] | select(.description | contains($mon)) | .activeWorkspace.id'
    else
        hyprctl activeworkspace -j | jq -r '.id'
    fi
}

get_workspaces_tooltip() {
    # Get workspaces with windows (non-empty, non-special)
    active_ws=$(hyprctl workspaces -j | jq -r '.[] | select(.id > 0 and .windows > 0) | .id' | sort -n | tr '\n' ' ')
    
    if [[ -n "$active_ws" ]]; then
        echo "Active: $active_ws"
    else
        echo "No active workspaces"
    fi
}

current="$(get_current_workspace)"
tooltip="$(get_workspaces_tooltip)"

jq -nc \
  --arg text "$current" \
  --arg tooltip "$tooltip" \
  '{
     text: $text,
     tooltip: $tooltip,
     class: "workspace"
   }'