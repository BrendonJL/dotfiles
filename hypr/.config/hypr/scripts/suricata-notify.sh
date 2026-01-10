#!/bin/bash

LOGFILE="/var/log/suricata/eve.json"
CACHE_DIR="/tmp/suricata-notify-cache"
CACHE_TIMEOUT=300

mkdir -p "$CACHE_DIR"
find "$CACHE_DIR" -type f -mmin +5 -delete 2>/dev/null

tail -F "$LOGFILE" 2>/dev/null | while read -r line; do
    # Check for drop events
    if echo "$line" | grep -q '"action":"drop"'; then
        # Extract info from JSON
        src_ip=$(echo "$line" | grep -oP '"src_ip"\s*:\s*"\K[^"]+')
        dest_ip=$(echo "$line" | grep -oP '"dest_ip"\s*:\s*"\K[^"]+')
        dest_port=$(echo "$line" | grep -oP '"dest_port"\s*:\s*\K[0-9]+')
        
        # Skip localhost traffic
        if [ "$src_ip" = "127.0.0.1" ] && [ "$dest_ip" = "127.0.0.1" ]; then
            continue
        fi
        
        # Create hash for deduplication
        alert_hash=$(echo "$src_ip$dest_ip$dest_port" | md5sum | cut -d' ' -f1)
        cache_file="$CACHE_DIR/$alert_hash"
        
        if [ -f "$cache_file" ]; then
            continue
        fi
        
        touch "$cache_file"
        
        # Send notification
        connection="${src_ip} -> ${dest_ip}:${dest_port}"
        notify-send -a "Suricata" -u critical "Suricata Drop" "Traffic blocked: $connection" 2>/dev/null &
    fi
done