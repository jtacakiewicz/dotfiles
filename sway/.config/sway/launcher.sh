#!/bin/sh

# Grab the focused monitor name using awk
TARGET=$(swaymsg -t get_outputs | awk '/"name":/ {name=$2; gsub(/[",]/,"",name)} /"focused": true/ {print name}')

# Launch tofi on that specific monitor
tofi-drun --drun-launch=true --output "$TARGET"
