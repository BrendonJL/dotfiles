#!/bin/bash
# Scrolling news ticker for waybar

CACHE_FILE="/tmp/newsboat_headlines"
CACHE_AGE=1800  # Refresh headlines every 30 minutes
SCROLL_FILE="/tmp/news_scroll_pos"
TICKER_LENGTH=50  # Characters to show

# Refresh cache if old
if [[ ! -f "$CACHE_FILE" ]] || [[ $(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") )) -gt $CACHE_AGE ]]; then
    # Reload newsboat and extract headlines
    newsboat -x reload 2>/dev/null
    
    # Get headlines from newsboat database, clean special chars
    sqlite3 ~/.local/share/newsboat/cache.db \
        "SELECT title FROM rss_item WHERE unread=1 ORDER BY pubDate DESC LIMIT 20" 2>/dev/null \
        | tr '\n' ' ' | sed 's/"/\\"/g' | sed "s/'/\\'/g" | tr -d '\r' > "$CACHE_FILE"
fi

# Read headlines
headlines=$(cat "$CACHE_FILE" 2>/dev/null | tr -d '\n\r')

if [[ -z "$headlines" ]]; then
    headlines="No news available"
fi

# Add separator and padding for smooth loop
headlines="$headlines 󰇝 $headlines 󰇝 "

# Get scroll position
scroll_pos=$(cat "$SCROLL_FILE" 2>/dev/null || echo 0)
headline_len=${#headlines}

# Extract visible portion
visible="${headlines:$scroll_pos:$TICKER_LENGTH}"

# Increment scroll position
next_pos=$(( (scroll_pos + 1) % (headline_len / 2) ))
echo "$next_pos" > "$SCROLL_FILE"

# Build tooltip - top headline from each feed
tooltip=$(sqlite3 ~/.local/share/newsboat/cache.db \
    "SELECT f.title || ': ' || substr(i.title, 1, 40)
     FROM rss_item i 
     JOIN rss_feed f ON i.feedurl = f.rssurl 
     WHERE i.unread=1 
     GROUP BY f.rssurl 
     ORDER BY i.pubDate DESC 
     LIMIT 6" 2>/dev/null | tr '\n' '\n')

if [[ -z "$tooltip" ]]; then
    tooltip="No unread articles"
fi

#!/bin/bash
# Scrolling news ticker for waybar

CACHE_FILE="/tmp/newsboat_headlines"
CACHE_AGE=1800  # Refresh headlines every 30 minutes
SCROLL_FILE="/tmp/news_scroll_pos"
TICKER_LENGTH=50  # Characters to show

# Refresh cache if old
if [[ ! -f "$CACHE_FILE" ]] || [[ $(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") )) -gt $CACHE_AGE ]]; then
   # Reload newsboat and extract headlines
   newsboat -x reload 2>/dev/null
   
   # Get headlines from newsboat database, clean special chars
   sqlite3 ~/.local/share/newsboat/cache.db \
       "SELECT title FROM rss_item WHERE unread=1 ORDER BY pubDate DESC LIMIT 20" 2>/dev/null \
       | tr '\n' ' ' | sed 's/"/\\"/g' | sed "s/'/\\'/g" | tr -d '\r' > "$CACHE_FILE"
fi

# Read headlines
headlines=$(cat "$CACHE_FILE" 2>/dev/null | tr -d '\n\r')
if [[ -z "$headlines" ]]; then
   headlines="No news available"
fi

# Escape ampersands for Pango markup
headlines="${headlines//&/&amp;}"

# Add separator and padding for smooth loop
headlines="$headlines 󰇝 $headlines 󰇝 "

# Get scroll position
scroll_pos=$(cat "$SCROLL_FILE" 2>/dev/null || echo 0)
headline_len=${#headlines}

# Extract visible portion
visible="${headlines:$scroll_pos:$TICKER_LENGTH}"

# Increment scroll position
next_pos=$(( (scroll_pos + 1) % (headline_len / 2) ))
echo "$next_pos" > "$SCROLL_FILE"

# Build tooltip - top headline from each feed
tooltip=$(sqlite3 ~/.local/share/newsboat/cache.db \
   "SELECT f.title || ': ' || substr(i.title, 1, 40) 
    FROM rss_item i  
      JOIN rss_feed f ON i.feedurl = f.rssurl  
      WHERE i.unread=1  
      GROUP BY f.rssurl  
      ORDER BY i.pubDate DESC  
      LIMIT 6" 2>/dev/null | tr '\n' '\n')

if [[ -z "$tooltip" ]]; then
   tooltip="No unread articles"
fi

# Escape ampersands in tooltip too
tooltip="${tooltip//&/&amp;}"

# Output JSON using jq for proper escaping
jq -nc \
   --arg text "󰎕 $visible" \
   --arg tooltip "$tooltip" \
   '{text: $text, tooltip: $tooltip, class: "news"}'