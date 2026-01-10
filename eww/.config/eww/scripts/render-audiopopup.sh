#!/bin/bash
eww update audio_vol="$(pamixer --get-volume)" 2>/dev/null
eww update audio_muted="$(pamixer --get-mute)" 2>/dev/null