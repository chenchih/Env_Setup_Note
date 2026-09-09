# Capture OTA/Air WiFi Packet

## Airmon Setup
Airmon is a tool that allow to capture wireless packet on air, so I'm going to show the basic command to use.


### Installation
```
 sudo apt install aircrack-ng  -y
 sudo apt install wireshark  -y
 
```
Note: aircrack-ng will include airmon-ng this tool. 


We need to use wireshark to cpature the packet, so please also install wireshark

### How to use Airmon-ng

- Start Capture

1. Before capture kill exist services
```
sudo airmon-ng check kill
```

I think `sudo iwconfig wlan0 mode monitor` is optional

2. Check wlan interface `ifconfig` or `iwconfig`

3. Start air cap
`wlan0` is my wireless interface

```
sudo airmon-ng start wlan0
```
it will turn you interface to wlan0mon

you can also specify band `sudo airmon-ng wlan0mon --band abg`

4. set channel 
```
sudo iw dev wlan0mon set channel 36
```
5. open wireshark and click on montior 
```
sudo wireshark
```

- Stop Capture
1. stop cpature 
```
sudo airmon-ng stop wlan0mon
```
2. Restart network
```
sudo systemctl restart NetworkManager
```

### How to use my automation script

- Start Capture
```
sudo ./start_monitor.sh wlan0 8
```

- stop Capture
```
sudo ./stop_monitor.sh wlan0mon
```


## iw command 

You can use iw command to capture, or use the script `sniffer_disable.sh` or `sniffer_enable.sh`

> syntax: `iw dev wlan0 set freq <control_freq> <bandwidth> <center_freq>`

- Set channel
```
iw dev wlan0 set channel 36 
```

- explicit band
```
iw dev wlan0 set channel 36 HT20
```

- freq
```
iw dev wlan0 set freq 5955
iw dev wlan0 set freq 5955 320 6105
```

