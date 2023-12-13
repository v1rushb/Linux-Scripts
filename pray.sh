#!/bin/bash

DATE=$(date '+%d-%m-%Y')
JSON=$(curl "http://api.aladhan.com/v1/timingsByCity/'$(DATE)'?city=Hebron&country=Palestine")

FAJR=$(echo $JSON | jq -r '.data.timings.Fajr')
SUNRISE=$(echo $JSON | jq -r '.data.timings.Sunrise')
DHUHR=$(echo $JSON | jq -r '.data.timings.Dhuhr')
ASR=$(echo $JSON | jq -r '.data.timings.Asr')
MAGHRIB=$(echo $JSON | jq -r '.data.timings.Maghrib')
ISHA=$(echo $JSON | jq -r '.data.timings.Isha')

NOW=$(date +%H:%M)

is_time_greater() {
    [ "$1" = "$(echo -e "$1\n$2" | sort -r | head -n1)" ]
}

NEXT_PRAYER=""
NEXT_PRAYER_TIME=""

if is_time_greater "$NOW" "$ISHA"; then
    NEXT_PRAYER="Fajr"
    NEXT_PRAYER_TIME=$FAJR
elif is_time_greater "$NOW" "$MAGHRIB"; then
    NEXT_PRAYER="Isha"
    NEXT_PRAYER_TIME=$ISHA
elif is_time_greater "$NOW" "$ASR"; then
    NEXT_PRAYER="Maghrib"
    NEXT_PRAYER_TIME=$MAGHRIB
elif is_time_greater "$NOW" "$DHUHR"; then
    NEXT_PRAYER="Asr"
    NEXT_PRAYER_TIME=$ASR
elif is_time_greater "$NOW" "$SUNRISE"; then
    NEXT_PRAYER="Dhuhr"
    NEXT_PRAYER_TIME=$DHUHR
elif is_time_greater "$NOW" "$FAJR"; then
    NEXT_PRAYER="Sunrise"
    NEXT_PRAYER_TIME=$SUNRISE
else
    NEXT_PRAYER="Fajr"
    NEXT_PRAYER_TIME=$FAJR
fi


calculate_time_remaining() {
    local prayer_time=$1
    local current_epoch=$(date +%s)
    local prayer_epoch=$(date -d "$prayer_time" +%s)
    local remaining_seconds=$((prayer_epoch - current_epoch))

    if [ $remaining_seconds -lt 0 ]; then
        echo "Prayer time has passed."
    else
        local hours=$((remaining_seconds / 3600))
        local minutes=$(((remaining_seconds % 3600) / 60))
        local seconds=$((remaining_seconds % 60))
        printf "Time remaining for prayer: %02d:%02d:%02d\n" $hours $minutes $seconds
    fi
}

echo "Next prayer is $NEXT_PRAYER at $NEXT_PRAYER_TIME"
calculate_time_remaining $NEXT_PRAYER_TIME
