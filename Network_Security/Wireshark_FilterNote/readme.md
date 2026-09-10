# Wireshark Filter CheatSheat 

## Wirless 

- Capture wlan mac address : 

Show only the 802.11-based traffic 

```
wlan.addr==XX:XX:XX:XX:XX`  
```

- Ap BSSID: `wlan.bssid==XX:XX:XX:XX:XX`

```
wlan.ssid==XXXX

#or
wlan_mgt.ssid == "Spatula City"
```

- beacon only: 

```
wlan.fc.type==0 && wlan.fc.subtype==8
```

- Probe requests: 

```
wlan.fc.type == 0 && wlan.fc.subtype == 4
```

- Probe responses: 

```
wlan.fc.type == 0 && wlan.fc.subtype == 5
```

- WPS: 

```
eap
```

- Filter Wi-Fi traffic for a specific host

```
wlan host XXXXXXXX`
```

- Hide beacon: 

``` 
wlan.fc.type_subtype != 0x08
```

- Filter out beacon frames: 

```
wlan[0] != 0x80
```