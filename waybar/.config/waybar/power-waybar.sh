#!/bin/bash
# Power button with uptime tooltip

uptime_info=$(uptime -p | sed 's/up //')

echo "{\"text\": \"⏻\", \"tooltip\": \"Uptime: $uptime_info\", \"class\": \"power\"}"