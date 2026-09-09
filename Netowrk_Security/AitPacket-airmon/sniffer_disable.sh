#!/bin/sh

INTERFACE=$1
#ifconfig wlan0 down
ifconfig $INTERFACE down
#iw dev wlan0 set type managed
iw dev $INTERFACE set type managed
sleep 2
#ifconfig wlan0 up
ifconfig $INTERFACE up
sleep 2
#nmcli d set wlan0 managed yes
nmcli d set $INTERFACE managed yes
#iw dev wlan0 set channel 6
#iw dev wlan0 set freq 5180 80 5210
