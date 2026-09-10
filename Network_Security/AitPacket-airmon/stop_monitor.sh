#!/bin/bash

#moniface="wlp0s20f3mon"

#airmon-ng stop "$moniface"

# Restart normal network services
#systemctl restart NetworkManager 2>/dev/null || true

#iw dev



# Ensure an interface is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <monitor-interface>"
  echo "Example: $0 wlan0mon"
  exit 1
fi

INTERFACE=$1

echo "Stopping monitor mode on $INTERFACE..."
airmon-ng stop "$INTERFACE"

echo "Restarting NetworkManager to restore standard internet connection..."
systemctl restart NetworkManager
# service networking restart # Uncomment if your system uses 'networking' instead of NetworkManager

echo "Monitor mode disabled. Normal networking restored."
