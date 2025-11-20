#!/bin/bash

# Show current connection
current=$(nmcli -t -f NAME connection show --active | head -n 1)

# Get list of available WiFi networks (use cached data for speed)
networks=$(nmcli -f SSID,SIGNAL,SECURITY device wifi list --rescan no | tail -n +2)

# Add scan option at the top
menu="🔄 Scan for networks
$networks"

# Use wofi to display networks and get selection
selected=$(echo "$menu" | wofi --dmenu --prompt "WiFi Networks (Current: $current)")

if [ -n "$selected" ]; then
    # Check if user selected the scan option
    if [ "$selected" = "🔄 Scan for networks" ]; then
        # Trigger a rescan (takes 1-2 seconds)
        nmcli device wifi list >/dev/null 2>&1
        # Reopen the menu with fresh results
        exec "$0"
        exit 0
    fi

    # Extract SSID (first field)
    ssid=$(echo "$selected" | awk '{print $1}')

    # Check if network has security
    security=$(echo "$selected" | awk '{print $3}')

    if [ "$security" != "--" ]; then
        # Network is secured, prompt for password
        password=$(wofi --dmenu --password --prompt "Password for $ssid" 2>/dev/null)
        if [ -n "$password" ]; then
            nmcli device wifi connect "$ssid" password "$password"
        fi
    else
        # Open network
        nmcli device wifi connect "$ssid"
    fi
fi
