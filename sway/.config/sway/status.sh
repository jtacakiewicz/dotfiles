#!/usr/bin/env bash
while true; do
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -n1 | tr -d '[:space:]')
    
    [ -z "$vol" ] && vol=0
    
    pos=$(( (vol + 5) / 10 ))
    [ $pos -gt 10 ] && pos=10

    bar="───────────"
    slider="${bar:0:pos}○${bar:pos+1}"

    printf "%s %d%% │ %s\n" "$slider" "$vol" "$(date "+%A, %d %B | %H:%M:%S")"

    sleep 1
done
