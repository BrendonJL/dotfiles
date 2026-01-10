#!/bin/bash
# Animated weather for waybar

LOCATION="Alexandria,Virginia"
CACHE_FILE="/tmp/weather_cache"
CACHE_AGE=600  # Update weather every 10 minutes

# Fetch weather if cache is old or missing
if [[ ! -f "$CACHE_FILE" ]] || [[ $(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") )) -gt $CACHE_AGE ]]; then
    weather_data=$(curl -s "wttr.in/${LOCATION}?format=%c|%t|%C|%h|%w&u" 2>/dev/null)
    if [[ -n "$weather_data" ]]; then
        echo "$weather_data" > "$CACHE_FILE"
    fi
fi

# Read cached weather
weather_data=$(cat "$CACHE_FILE" 2>/dev/null)
IFS='|' read -r icon temp condition humidity wind <<< "$weather_data"

# Clean up temp
temp=$(echo "$temp" | tr -d ' ')

# Animation frame from counter file 
FRAME_FILE="/tmp/weather_frame_$PPID"
frame=$(cat "$FRAME_FILE" 2>/dev/null || echo 0)
next_frame=$(( (frame + 1) % 6 ))
echo "$next_frame" > "$FRAME_FILE"

# Determine animation based on condition
condition_lower=$(echo "$condition" | tr '[:upper:]' '[:lower:]')

case "$condition_lower" in
    *rain*|*drizzle*|*shower*)
        anim_frames=("󰖗 󰖖 󰖗" "󰖖 󰖗 󰖖" "󰖗 󰖖 󰖗" "󰖖 󰖗 󰖖" "󰖗 󰖖 󰖗" "󰖖 󰖗 󰖖")
        class="rain"
        ;;
    *snow*|*sleet*|*ice*)
        anim_frames=("❄ ❅ ❆" "❅ ❆ ❄" "❆ ❄ ❅" "❄ ❅ ❆" "❅ ❆ ❄" "❆ ❄ ❅")
        class="snow"
        ;;
    *thunder*|*storm*)
        anim_frames=("⛈ ⛈ ⛈" "⛈ ⚡ ⛈" "⛈ ⛈ ⛈" "⚡ ⛈ ⚡" "⛈ ⛈ ⛈" "⛈ ⚡ ⛈")
        class="storm"
        ;;
    *cloud*|*overcast*)
        anim_frames=("☁ ⛅ ☁" "⛅ ☁ ⛅" "☁ ⛅ ☁" "⛅ ☁ ⛅" "☁ ⛅ ☁" "⛅ ☁ ⛅")
        class="cloudy"
        ;;
    *sun*|*clear*)
        anim_frames=("☀ ✺ ☼" "✺ ☼ ❂" "☼ ❂ ☀" "❂ ☀ ✺" "☀ ✺ ☼" "✺ ☼ ❂")
        class="sunny"
        ;;
    *fog*|*mist*|*haze*)
        anim_frames=("🌫 ░ 🌫" "░ 🌫 ░" "🌫 ░ 🌫" "░ 🌫 ░" "🌫 ░ 🌫" "░ 🌫 ░")
        class="foggy"
        ;;
    *wind*)
        anim_frames=("🌬 〰 🌬" "〰 🌬 〰" "🌬 〰 🌬" "〰 🌬 〰" "🌬 〰 🌬" "〰 🌬 〰")
        class="windy"
        ;;
    *)
        anim_frames=("$icon $icon $icon" "$icon $icon $icon" "$icon $icon $icon" "$icon $icon $icon" "$icon $icon $icon" "$icon $icon $icon")
        class="default"
        ;;
esac

anim_icon="${anim_frames[$frame]}"

# Build tooltip
tooltip="$condition\n󰔏 $temp  💧 $humidity  💨 $wind"

# Output JSON
printf '{"text": "%s %s", "tooltip": "%s", "class": "%s"}\n' "$anim_icon" "$temp" "$tooltip" "$class"
