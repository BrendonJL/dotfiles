#!/bin/bash

# Rofi Meta Launcher

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
WALLPAPER_SAVE="$HOME/.config/rofi/current_wallpaper"

main_menu() {
    echo -e "Apps\0icon\x1fapplications-other"
    echo -e "Windows\0icon\x1fpreferences-system-windows"
    echo -e "Emoji\0icon\x1fface-smile"
    echo -e "Clipboard\0icon\x1fedit-paste"
    echo -e "Calculator\0icon\x1faccessories-calculator"
    echo -e "Search\0icon\x1fsystem-search"
    echo -e "Files\0icon\x1fsystem-file-manager"
    echo -e "Kill\0icon\x1fprocess-stop"
    echo -e "Wallpaper\0icon\x1fpreferences-desktop-wallpaper"
    echo -e "Screenshot\0icon\x1fapplets-screenshooter"
    echo -e "Record\0icon\x1fmedia-record"
    echo -e "Typing\0icon\x1finput-keyboard"
}

search_menu() {
    query=$(rofi -dmenu -p "🔍" -theme ~/.config/rofi/search-only.rasi)
    [[ -z "$query" ]] && exit 0

    engine=$(echo -e "🌐  Google\n▶️  YouTube\n💻  GitHub\n🤖  Reddit" | rofi -dmenu -p "🔍" -theme ~/.config/rofi/purple-cat.rasi)
    [[ -z "$engine" ]] && exit 0

    encoded=$(echo "$query" | sed 's/ /+/g')

    case "$engine" in
        "🌐  Google") xdg-open "https://google.com/search?q=$encoded" ;;
        "▶️  YouTube") xdg-open "https://youtube.com/results?search_query=$encoded" ;;
        "💻  GitHub") xdg-open "https://github.com/search?q=$encoded" ;;
        "🤖  Reddit") xdg-open "https://reddit.com/search/?q=$encoded" ;;
    esac
    exit 0  # Selection made - exit completely
}

kill_menu() {
    selected=$(ps aux --sort=-%mem | awk 'NR>1 {
        mem=$4
        pid=$2
        cmd=$11
        # Get basename only
        n=split(cmd, parts, "/")
        cmd=parts[n]
        if (length(cmd) > 25) cmd = substr(cmd, 1, 22) "..."
        printf "%-25s  %5s%%  [%s]\n", cmd, mem, pid
    }' | head -20 | rofi -dmenu -p "Kill Process" -i -theme ~/.config/rofi/simple-menu.rasi)
    [[ -z "$selected" ]] && exit 0

    pid=$(echo "$selected" | grep -oE '\[[0-9]+\]' | tr -d '[]')
    kill "$pid" 2>/dev/null || kill -9 "$pid" 2>/dev/null
    exit 0
}

screenshot_menu() {
    choice=$(echo -e "Region\nWindow\nFull Screen" | rofi -dmenu -p "Screenshot" -i -theme ~/.config/rofi/simple-menu.rasi)
    [[ -z "$choice" ]] && exit 0
    case "$choice" in
        Region) ~/.config/hypr/scripts/satty-region.sh ;;
        Window) ~/.config/hypr/scripts/satty-window.sh ;;
        "Full Screen") ~/.config/hypr/scripts/satty-full.sh ;;
    esac
    exit 0
}

record_menu() {
    choice=$(echo -e "Region\nFull Screen" | rofi -dmenu -p "Record" -i -theme ~/.config/rofi/simple-menu.rasi)
    [[ -z "$choice" ]] && exit 0
    case "$choice" in
        Region) ~/.config/hypr/scripts/record.sh region ;;
        "Full Screen") ~/.config/hypr/scripts/record.sh ;;
    esac
    exit 0
}

window_menu() {
    # Build rofi menu with app icons (exclude special workspaces)
    selected=$(hyprctl clients -j | jq -c '.[] | select(.workspace.id >= 0)' | while read -r win; do
        addr=$(echo "$win" | jq -r '.address')
        class=$(echo "$win" | jq -r '.class')
        title=$(echo "$win" | jq -r '.title' | cut -c1-30)
        # Use class as icon name, put address at end so it gets cut off
        echo -e "${title} ${addr}\0icon\x1f${class}"
    done | rofi -dmenu -p "🖥️ Windows" -i -show-icons -theme ~/.config/rofi/window-grid.rasi)

    [[ -z "$selected" ]] && exit 0

    # Extract window address from end of selection
    address=$(echo "$selected" | grep -oE '0x[a-f0-9]+')
    hyprctl dispatch focuswindow "address:$address"
    exit 0
}

wallpaper_menu() {
    THUMB_DIR="$WALLPAPER_DIR/thumbnails"

    # Build menu from video wallpapers (using glob instead of find for speed)
    selected=$(for file in "$WALLPAPER_DIR"/*.{mp4,webm,mkv}; do
        [[ -f "$file" ]] || continue
        name="${file##*/}"
        name="${name%.*}"
        echo -e "$name\0icon\x1f$THUMB_DIR/$name.png"
    done | rofi -dmenu -p "🖼️ Wallpaper" -i -show-icons -theme ~/.config/rofi/wallpaper-grid.rasi)
    [[ -z "$selected" ]] && exit 0

    # Find the full path (check common extensions)
    for ext in mp4 webm mkv; do
        [[ -f "$WALLPAPER_DIR/$selected.$ext" ]] && { wallpaper_path="$WALLPAPER_DIR/$selected.$ext"; break; }
    done
    [[ -z "$wallpaper_path" ]] && exit 0

    # Save selection for startup script
    echo "$wallpaper_path" > "$WALLPAPER_SAVE"

    # Switch wallpaper (gslapper handles fade transition)
    pkill -x gslapper 2>/dev/null
    pkill -x gslapper-holder 2>/dev/null
    sleep 0.1
    gslapper -f --transition-type fade --transition-duration 0.8 -o "loop fill" '*' "$wallpaper_path" &

    # Generate colors while wallpaper loads (run in parallel)
    thumbnail="$THUMB_DIR/$selected.png"
    if [[ -f "$thumbnail" ]]; then
        # Run matugen in background, then reload apps when done
        (
            ~/.cargo/bin/matugen image "$thumbnail"

            # Restart waybar instances
            pkill -x waybar 2>/dev/null
            sleep 0.2
            waybar -c ~/.config/waybar/config &
            waybar -c ~/.config/waybar/config-laptop &
            waybar -c ~/.config/waybar/config-right &

            # Reload eww and swaync
            eww reload &
            swaync-client -rs &
        ) &
    fi

    exit 0
}

# Main menu with grid layout
chosen=$(main_menu | rofi -dmenu -p "🔍" -i -show-icons -theme ~/.config/rofi/main-grid.rasi)

# Exit if nothing selected (Escape pressed)
[ -z "$chosen" ] && exit 0

case "$chosen" in
    "Apps") rofi -show drun ;;
    "Windows") window_menu ;;
    "Emoji") rofimoji --hidden-descriptions --selector-args="-theme ~/.config/rofi/emoji-grid.rasi" ;;
    "Clipboard")
        # Create temp dir for image thumbnails
        CLIP_THUMB_DIR="/tmp/cliphist-thumbs"
        mkdir -p "$CLIP_THUMB_DIR"

        # Build menu with image previews (limit to 15 recent items)
        selected=$(cliphist list | head -15 | while IFS= read -r line; do
            id="${line%%	*}"
            content="${line#*	}"

            # Check if it's an image entry
            if [[ "$content" == *"[[ binary data"*"png"* ]] || [[ "$content" == *"[[ binary data"*"jpeg"* ]] || [[ "$content" == *"[[ binary data"*"jpg"* ]]; then
                # Extract thumbnail
                thumb="$CLIP_THUMB_DIR/$id.png"
                if [[ ! -f "$thumb" ]]; then
                    cliphist decode <<< "$line" | magick - -resize 128x128 "$thumb" 2>/dev/null
                fi
                if [[ -f "$thumb" ]]; then
                    echo -e "${line}\0icon\x1f${thumb}"
                else
                    echo "$line"
                fi
            else
                echo "$line"
            fi
        done | rofi -dmenu -p "Clipboard" -i -show-icons -theme ~/.config/rofi/clipboard.rasi)
        [[ -z "$selected" ]] && exit 0
        echo "$selected" | cliphist decode | wl-copy
        ;;
    "Calculator") rofi -show calc -modi calc -no-show-match -no-sort -theme ~/.config/rofi/calculator.rasi ;;
    "Search") search_menu ;;
    "Files") rofi -show filebrowser ;;
    "Kill") kill_menu ;;
    "Wallpaper") wallpaper_menu ;;
    "Screenshot") screenshot_menu ;;
    "Record") record_menu ;;
    "Typing") konsole --profile "Typing Game" -e /home/blasley/.nvm/versions/node/v24.11.1/bin/tgc -b --topic belgariad ;;
esac
