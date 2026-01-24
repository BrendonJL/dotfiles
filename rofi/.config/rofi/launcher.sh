#!/bin/bash

# Rofi Meta Launcher

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
WALLPAPER_SAVE="$HOME/.config/rofi/current_wallpaper"

main_menu() {
    echo -e "🚀  Apps\n🖥️  Windows\n😊  Emoji\n📋  Clipboard\n🔢  Calculator\n🔍  Search\n📁  Files\n💀  Kill Process\n🖼️  Wallpaper\n📸  Screenshot\n🎬  Record\n⌨️  Typing Game"
}

search_menu() {
    query=$(rofi -dmenu -p "🔍 Search")
    [[ -z "$query" ]] && exit 0

    engine=$(echo -e "🌐  Google\n▶️  YouTube\n💻  GitHub\n🤖  Reddit" | rofi -dmenu -p "Where")
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
        if (length(cmd) > 20) cmd = substr(cmd, 1, 17) "..."
        printf "⚙️ %s %s%% %s\n", pid, mem, cmd
    }' | head -20 | rofi -dmenu -p "💀 Kill" -i)
    [[ -z "$selected" ]] && exit 0

    pid=$(echo "$selected" | awk '{print $2}')
    kill "$pid" 2>/dev/null || kill -9 "$pid" 2>/dev/null
    exit 0  # Selection made - exit completely
}

screenshot_menu() {
    choice=$(echo -e "Region\nWindow\nFull Screen" | rofi -dmenu -p "Screenshot" -i)
    [[ -z "$choice" ]] && exit 0
    case "$choice" in
        Region) ~/.config/hypr/scripts/satty-region.sh ;;
        Window) ~/.config/hypr/scripts/satty-window.sh ;;
        "Full Screen") ~/.config/hypr/scripts/satty-full.sh ;;
    esac
    exit 0
}

record_menu() {
    choice=$(echo -e "Region\nFull Screen" | rofi -dmenu -p "Record" -i)
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

    selected=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.mp4" -o -name "*.webm" -o -name "*.mkv" \) 2>/dev/null | while read -r file; do
        filename=$(basename "$file")
        name="${filename%.*}"
        thumb="$THUMB_DIR/$name.png"
        # Use rofi icon syntax: text\0icon\x1f/path/to/icon
        echo -e "$name\0icon\x1f$thumb"
    done | rofi -dmenu -p "🖼️ Wallpaper" -i -show-icons -theme ~/.config/rofi/wallpaper-grid.rasi)
    [[ -z "$selected" ]] && exit 0

    # Find the full path for selected wallpaper
    wallpaper_path=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f -name "$selected.*" | head -1)

    [[ -z "$wallpaper_path" ]] && exit 0

    # Save selection for startup script
    echo "$wallpaper_path" > "$WALLPAPER_SAVE"

    # Show splash overlay during transition (close any existing first)
    eww close splash 2>/dev/null; eww close splash-1 2>/dev/null; eww close splash-2 2>/dev/null
    eww open splash & eww open splash-1 & eww open splash-2 &
    sleep 0.2
    killall mpvpaper 2>/dev/null
    mpvpaper -o "no-audio loop keepaspect=no" '*' "$wallpaper_path" &
    sleep 2.5
    eww close splash & eww close splash-1 & eww close splash-2 &

    # Generate colors from wallpaper thumbnail using matugen
    wallpaper_name=$(basename "$wallpaper_path" | sed 's/\.[^.]*$//')
    thumbnail="$THUMB_DIR/$wallpaper_name.png"
    if [ -f "$thumbnail" ]; then
        ~/.cargo/bin/matugen image "$thumbnail"
        # Restart waybar with new colors
        killall waybar 2>/dev/null
        waybar -c ~/.config/waybar/config &
        waybar -c ~/.config/waybar/config-laptop &
        waybar -c ~/.config/waybar/config-right &
        # Reload eww styles
        eww reload &
    fi

    exit 0  # Selection made - exit completely
}

# Main loop - keeps returning to menu until you press Escape from main menu
while true; do
    chosen=$(main_menu | rofi -dmenu -p "Launch" -i)

    # Exit if nothing selected (Escape pressed)
    [ -z "$chosen" ] && exit 0

    case "$chosen" in
        "🚀  Apps") rofi -show drun; exit 0 ;;
        "🖥️  Windows") window_menu ;;
        "😊  Emoji") rofimoji --hidden-descriptions --selector-args="-theme ~/.config/rofi/emoji-grid.rasi" && exit 0 ;;
        "📋  Clipboard")
            selected=$(cliphist list | rofi -dmenu)
            [[ -z "$selected" ]] && exit 0
            echo "$selected" | cliphist decode | wl-copy
            exit 0
            ;;
        "🔢  Calculator") rofi -show calc -modi calc -no-show-match -no-sort; exit 0 ;;
        "🔍  Search") search_menu ;;
        "📁  Files") rofi -show filebrowser; exit 0 ;;
        "💀  Kill Process") kill_menu ;;
        "🖼️  Wallpaper") wallpaper_menu ;;
        "📸  Screenshot") screenshot_menu ;;
        "🎬  Record") record_menu ;;
        "⌨️  Typing Game") konsole --profile "Typing Game" -e /home/blasley/.nvm/versions/node/v24.11.1/bin/tgc -b --topic belgariad; exit 0 ;;
    esac
done
