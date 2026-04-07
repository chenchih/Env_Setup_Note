
## Install Driver 

1. Check System

- check kernel
Check kernel must be at least kernel 6.6 or newer. This driver won't work on older kernels.
```
uname -r
#6.8.0-87-generic
```

- check OS System 
cat /etc/*release

![SystemKernelVersion](img/systermKernVersion.png)

2. Verify USB Adapter Detection
- device is listed on the USB bus:

Use `lsusb` to list connected USB devices.

```
lsusb
```

![detectUsbAdapter](img/DetectUsbAdapter.png)


- Checking Kernel Logs

Check dmesg logs for USB connection events:
```
dmesg | grep -i usb
```
![detectUsbAdapte_Dmesh](img/dmesg_checkUSBadpater.png)

3. install package
```
sudo apt update
sudo apt install -y build-essential git dkms linux-headers-$(uname -r)
```

4. Clone  BE92 Driver Repository
Most BE92 USB adapters use:
Realtek RTL8922AU / RTL8852BU / RTL8832CU (WiFi 6/7 family)

```
git clone https://github.com/morrownr/rtw89.git
cd rtw89
```
5. Install driver

```
sudo make
sudo make install
```
![installDriver_error](img/make_errorSkip.png)

**Note**:Error msg can skip:
CC = compiling source files 
LD = linking module files 
.ko = built kernel modules 
Skipping BTF generation = warning/informational, usually safe to ignore

- to remove Conflicting Kernel Modules (optional)
If you have any existing rtw89 modules (from other attempts or older installations), clean them out:
```
sudo make cleanup_target_system
```

5. load module
```
sudo depmod -a
sudo modprobe rtw89_core_git
sudo modprobe rtw89_8922au_git
```

6. Check that modules are loaded:
```
lsmod |grep rtw89
```
![CheckLoadDriver](img/checkModule.png)

7. Check dmesg no errors and show firwmare infromation
```
sudo dmesg | grep rtw89
```
![CheckFw_DmesgLog](img/dmesg_WifiDriver.png)


8. Make sure firmware is installed: 
```
ls /lib/firmware/rtw89/
```
![CheckFWPath](img/FWlocation.png)


## Change Wireless Interface (optional)
Default Wireless interface name as format `wl<macaddress>` to not show mac address you can change your interface name by following method. If you want to stay as it was then you can skip this section. 

1. Create file `10-asus-usbwifi.link`
```
nano /etc/systemd/network/10-asus-usbwifi.link
```


2.	edit the file and add below content
You can check your mac address via `ip a` command

```
nano /etc/systemd/network/10-asus-usbwifi.link
```

please add your Wirless Mac like below content in the file:

```
[Match]
MACAddress=<Wireless Mac address XX:XX:XX:XX:XX:XX>

[Link]
Name=<interfaceName>
NamePolicy=
```


3. reboot your system


## Wireless command

### Check Interface
Now I will show you some command you can check your interface is up or not. 

1. Check wireless interface 
```
sudo apt install -y iw
```

2. Check all interface 

- show wireless interface 
```
iw dev
```

- show all interface 
```
ip link show
```

![ip link show](img/iplinkshow.PNG)

- show interface and ip address in readable format
```
ip –br a
```

![ip interface brief](img/interfacebreif.PNG)

- show connected status
```
nmcli device status
```

![/show connected status](img/interfaceStatus.PNG)



### Disable wireless 
If you have multiply interface and not knowing which one it used

```
nmcli device disconnect <wlan interface>
```
or 
```
sudo ip link set wlo1 down
```


### Scan and Connect Wifi command

- Scan
```
nmcli dev wifi list
```
explicit wlan interface to scan (if multiply wlan interface)

```
nmcli device wifi list ifname wlan0
```

![scan SSID](img/scanSSID.PNG)

you can use `grep` to filter specfic SSID. I use `-i` to ignore case senstive

![filter ssid scan](img/scan_grep.PNG)

- Filter option
You can also fitler specfic option 
```
# list all SSID and specify wireless interface
nmcli -f BSSID,SSID,FREQ,CHAN,RATE,SIGNAL,SECURITY device wifi list ifname wlan0

# filter ssid
nmcli -f BSSID,SSID,CHAN,SIGNAL,SECURITY device wifi list |grep SSID
```

- Rescan: force new scan
without `rescan` it uses cached results only

```
#rescan then show all result
nmcli dev wifi list --rescan yes

nmcli dev wifi list --rescan yes |grep ssid
#or just rescan 
sudo nmcli device wifi rescan
```

> `--rescan auto`:default behavior

![ssid connected](img/rescan.PNG)

- Connect

```
nmcli dev wifi connect "YOUR_WIFI_NAME" password "YOUR_PASSWORD"
#example
example: `nmcli device wifi connect "SSID1" password "1234567890"
```

![ssid connected](img/wifissid_connected.PNG)

you can also use `ask` option for asking password

```
sudo nmcli device wifi connect SSIDNAME --ask
```

- summary of connecting 
```
# 1. Drop the current guest connection
sudo nmcli device disconnect wlo1

# 2. Rescan as root
sudo nmcli device wifi rescan

# 3. Look for SSID again
nmcli device wifi list
```

### Check support 6Ghz

- Check suport 6Ghz

Get and set regulatory domain
```
iw reg get
#filter 6Ghz frequency
iw list | grep -Ei '6 GHz|5955|5975|6115|6435|6875|7115'
```

![6ghz disable](img/default_6ghz.PNG)

In Linux, cfg80211 starts with a highly restrictive world regulatory domain(country 00: DFS-UNSET). If it shows `00`, that is the generic world domain, and 6 GHz often stays unavailable there because Linux begins with restrictive defaults. 

You need to enable it according to which country you're. Each country might support different frequency, so you have to set correct region. 

- enable country code to enable 6Ghz
Let set correct country code and see if it can show 6ghz support 
> set country syntax: `sudo iw reg set <country ex: US, JP, TW..>`

```
sudo iw reg set TW
iw reg get
iw list | grep -Ei '6 GHz|5955|5975|6115|6435|6875|7115'
```
![after set 6ghz country](img/6ghz_enable_country.PNG)

After set country code, you can see it can detect some 6ghz frequency

- Scan SSID to see 6ghz 
You can scan SSID if DUT support triBand it will show all three band 2.4G, 5G, and 6Ghz, also 6Ghz band security as WPA3

![TriBand Scan result](img/ScanSsid6ghz.PNG)

### More Wireless Detail 

- Get info about WLAN connections (data rate, SSID, channel (MHz), signal strength, etc.)
```
sudo iw wlan0 info
```

### monitor quality 
- Get info about WLAN link quality
```
cat /proc/net/wireless
```

- update it every seconds like this:
```
watch -n 1 cat /proc/net/wireless
```

## Reference
- https://www.itdojo.com/courses-linux/linuxwifi/
- https://blog.alpaca.tw/posts/wifi-connect-with-command/