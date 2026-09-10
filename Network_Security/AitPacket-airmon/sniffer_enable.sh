#!/bin/sh


nmcli d set wlan0 managed no
ifconfig wlan0 down
iw dev wlan0 set type monitor
sleep 1
ifconfig wlan0 up
sleep 2
iw dev wlan0 set channel 6
#iw dev wlan0 set freq 5180 80 5210
