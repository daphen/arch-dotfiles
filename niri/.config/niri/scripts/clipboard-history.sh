#!/bin/bash
# Clipboard history picker using rofi and cliphist
cliphist list | rofi -dmenu -p "Clipboard" | cliphist decode | wl-copy
