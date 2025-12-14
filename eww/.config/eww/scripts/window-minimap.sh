#!/bin/bash

# Get focused window and all windows info
focused=$(niri msg focused-window 2>/dev/null)
windows=$(niri msg windows 2>/dev/null)

# Extract focused window's workspace and column
focused_workspace=$(echo "$focused" | grep "Workspace ID:" | awk '{print $3}')
focused_column=$(echo "$focused" | grep "Scrolling position:" | sed 's/.*column \([0-9]*\).*/\1/')

if [ -z "$focused_workspace" ] || [ -z "$focused_column" ]; then
    echo '[{"active":true}]'
    exit 0
fi

# Parse all windows on current workspace and get their columns
declare -A columns
while IFS= read -r line; do
    if [[ $line =~ "Window ID" ]]; then
        current_window="$line"
        in_focused_workspace=0
    elif [[ $line =~ "Workspace ID: $focused_workspace" ]]; then
        in_focused_workspace=1
    elif [[ $in_focused_workspace -eq 1 ]] && [[ $line =~ "Scrolling position: column "([0-9]+) ]]; then
        col="${BASH_REMATCH[1]}"
        columns[$col]=1
    fi
done <<< "$windows"

# If only one column, show single indicator
if [ ${#columns[@]} -le 1 ]; then
    echo '[{"active":true}]'
    exit 0
fi

# Build JSON array - sort columns and mark current position
sorted_cols=($(for col in "${!columns[@]}"; do echo "$col"; done | sort -n))

json="["
first=true
for col in "${sorted_cols[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        json="${json},"
    fi

    if [ "$col" -eq "$focused_column" ]; then
        json="${json}{\"active\":true}"
    else
        json="${json}{\"active\":false}"
    fi
done
json="${json}]"

echo "$json"
