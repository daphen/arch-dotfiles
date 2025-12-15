#!/bin/bash
# Kill any existing eww daemon instances
pkill -9 -x eww 2>/dev/null
rm -f /run/user/$(id -u)/eww-server_* 2>/dev/null
sleep 0.5

# Start daemon in background
eww daemon &

# Wait for IPC server to be ready (eww can take 8+ seconds to fully initialize)
sleep 8

# Open all windows on monitor 0 (order matters for z-stacking: frames first, then corners on top)
eww open-many bar frame-left frame-right frame-bottom corner-left corner-right corner-bottom-left corner-bottom-right

# Open all windows on monitor 1 (external display, silent fail if not present)
eww open-many bar-1 frame-left-1 frame-right-1 frame-bottom-1 corner-left-1 corner-right-1 corner-bottom-left-1 corner-bottom-right-1 2>/dev/null || true
