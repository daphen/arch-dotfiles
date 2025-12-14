#!/bin/bash

# Get all workspaces
workspaces=$(niri msg workspaces 2>/dev/null)

# Build JSON array of workspace states
json="["
first=true
while IFS= read -r line; do
    # Skip empty lines and output header
    [[ -z "$line" || "$line" =~ ^Output ]] && continue

    # Check if this is the active workspace (has *)
    if [[ "$line" =~ \* ]]; then
        active="true"
    else
        # Extract workspace number (skip if not a number line)
        ws=$(echo "$line" | tr -d ' ')
        if [[ ! "$ws" =~ ^[0-9]+$ ]]; then
            continue
        fi
        active="false"
    fi

    if [ "$first" = true ]; then
        first=false
    else
        json="${json},"
    fi
    json="${json}{\"active\":${active}}"
done <<< "$workspaces"

json="${json}]"
echo "$json"
