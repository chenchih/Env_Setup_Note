#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: sudo $0 <channel>"
    echo "Example: sudo $0 36"
    exit 1
fi


INTERFACE="$1"
CHANNEL="$2"
MON_IFACE="${INTERFACE}mon"

echo "Killing interfering processes..."
airmon-ng check kill

echo "Starting monitor mode on $INTERFACE..."
airmon-ng start "$INTERFACE"

echo "Setting $MON_IFACE to channel $CHANNEL..."
iw dev "$MON_IFACE" set channel "$CHANNEL"

echo "Done! $MON_IFACE is now listening on channel $CHANNEL."


#how to run
#sudo ./start_monitor.sh wlo1 8
