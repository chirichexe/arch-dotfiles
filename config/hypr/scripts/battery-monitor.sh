#!/bin/bash
# Low Battery Notification Script
# Monitors battery level and sends notifications

# Configuration
LOW_BATTERY_THRESHOLD=20
CRITICAL_BATTERY_THRESHOLD=10
CHECK_INTERVAL=60  # Check every 60 seconds

# Track notification state to avoid spam
NOTIFIED_LOW=false
NOTIFIED_CRITICAL=false

while true; do
    # Get battery percentage
    BATTERY_LEVEL=$(acpi -b | grep -P -o '[0-9]+(?=%)')
    BATTERY_STATUS=$(acpi -b | grep -o 'Discharging\|Charging\|Full')
    
    # Only send notifications when discharging
    if [ "$BATTERY_STATUS" = "Discharging" ]; then
        if [ "$BATTERY_LEVEL" -le "$CRITICAL_BATTERY_THRESHOLD" ] && [ "$NOTIFIED_CRITICAL" = false ]; then
            notify-send -u critical -i battery-caution "Critical Battery" "Battery level is at ${BATTERY_LEVEL}%! Please plug in your charger immediately."
            NOTIFIED_CRITICAL=true
            NOTIFIED_LOW=true
        elif [ "$BATTERY_LEVEL" -le "$LOW_BATTERY_THRESHOLD" ] && [ "$NOTIFIED_LOW" = false ]; then
            notify-send -u normal -i battery-low "Low Battery" "Battery level is at ${BATTERY_LEVEL}%. Consider plugging in your charger."
            NOTIFIED_LOW=true
        fi
    else
        # Reset notification flags when charging or full
        NOTIFIED_LOW=false
        NOTIFIED_CRITICAL=false
    fi
    
    sleep "$CHECK_INTERVAL"
done
