
# How to install WiFI 7 Adapter driver 
In this note I will show you how to install BE92 WiFi Driver from Realtek Chip. 

Note: 
In the market most often you saw Wifi7 usb dongle mention support TtialBrand (2.4G, 5G, and 6GHZ), MLO and etc. However realtech driver currently not support MLO Feature. 

If you want to use MLO, please use Intel chip like BE200 which will support all feature 6GHZ, and MLO. 

Most driver will only support window Driver as default, if you want to install Linux you can use my step. 

I have installed under HP Elitebook and work fine besides from MLO

## Check System Infotmation

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

you cn also filter the driver name
```
sudo dmesg | grep -i rtw89 | tail -n 10
```

## Install 

1. install package
```
sudo apt update
sudo apt install -y build-essential git dkms linux-headers-$(uname -r)
sudo apt install -y iw
```

2. Clone  BE92 Driver Repository
Most BE92 USB adapters use:
Realtek RTL8922AU / RTL8852BU / RTL8832CU (WiFi 6/7 family)

```
git clone https://github.com/morrownr/rtw89.git
cd rtw89
```
3. Install driver

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

- remove Conflicting Kernel Modules (optional)
If you have any existing rtw89 modules (from other attempts or older installations), clean them out:
```
sudo make cleanup_target_system
```

- Uninstall 

Check the version of the rtw89 driver installed in your system.
```
sudo dkms status rtw89
```

Remove the rtw89 driver and its source code (Change the driver version accordingly)

```
sudo dkms remove rtw89/6.15 --all
```
For users who installed the driver via make, run these commands in the rtw89 source directory
```
sudo make uninstall
sudo rm -f /etc/modprobe.d/rtw89.conf
```



4. load module
```
sudo depmod -a
sudo modprobe rtw89_core_git
sudo modprobe rtw89_8922au_git
```

5. Check that modules are loaded:
```
lsmod |grep rtw89
```
![CheckLoadDriver](img/checkModule.png)

6. Check dmesg no errors and show firwmare infromation
```
sudo dmesg | grep rtw89
```
![CheckFw_DmesgLog](img/dmesg_WifiDriver.png)


7. Make sure firmware is installed: 
```
ls /lib/firmware/rtw89/
```
![CheckFWPath](img/FWlocation.png)


## Change Wireless Interface (optional)

Default Wireless interface name format as `wl<macaddress>`. If you don't want to display the mac address or want to change a different name can set below method to change your interface name. 

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
In this section I will show how to use wireless command including how to scan, connect, check wireless information, and etc. 

### Check Interface
Now I will show you some command you can check your interface is up or not. 

#### Install iw package 

Please install `iw` package in order to use this tool. you can run with iw command to see if it's installed or not. 

```
sudo apt install -y iw
```

#### Checking interface information

- show interfaces and link-layer state

```
ip link show
```

![ip link show](img/iplinkshow.PNG)

- show interface and ip address in readable format

This is pretty useful to see IP address neater way instead of showing unrealted information. 
```
ip –br a
```
![ip interface brief](img/interfacebreif.PNG)

- show wireless interface 
This command allow to check your wireless information
```
iw dev
```
if you have multiply wireless interface then it will show `phy#0` .. `phy#1`

- show interface status 
This command will be use often when you want to check whether WiFi is connected
```
nmcli device status
```
![/show connected status](img/interfaceStatus.PNG)

### Disable wireless 

If you have multiply interface and not knowing which one it used, you can disable the onboard wireless interface. There're many different method you can disable or turn off wireless interface:


-	Method1: Force interface down (temporary)

This method will only temporary work, if you rebot it will restore back
```
#disconnect SSID
nmcli device disconnect <wlan1 interface>

# shitdown your wireless interface
sudo ip link set  <wlan1 interface>  down
sudo nmcli device set <wlan interface> managed no
sudo nmcli device connect  <wlan2 interface>
```

- Method2: Disable the Onboard Driver (Permanent & Clean)
This will take effect after reboot

1.	Find the driver name for the onboard card:
```
lspci -nnk | grep -i network -A 3
```

2. Add driver name into Blacklist

Replace `<driver_name>` with what you found above (e.g., iwlwifi)

```
echo "blacklist <driver_name>" | sudo tee /etc/modprobe.d/blacklist-onboard-wifi.conf
```

3. Apply and reboot

```
sudo update-initramfs -u
sudo reboot
```

4. Recover back to onboard

```
sudo rm /etc/modprobe.d/disable-onboard.conf
sudo update-initramfs -u
sudo reboot
```

### Scan SSID 

If `nmcli` command not support please install it:
```
sudo systemctl enable --now NetworkManager
```

- Scan using default interface

```
nmcli dev wifi list
```

- explicit wlan interface to scan (if multiply wlan interface)
If you have multiply wireless interface, you have to explicit your interface else it will use default. A better approah is to disable the wireless interface, and left with only one interface. 
```
nmcli device wifi list ifname <Wireless interfac>
```


![scan SSID](img/scanSSID.PNG)

- Filter option
you can use `grep` to filter specfic SSID, and use  `-i` option to ignore case senstive

![filter ssid scan](img/scan_grep.PNG)

- Scan with specifc field option

> sntax: `mcli -f [Field Name] device wifi list [Wireless Interface Name]`

```
# list all SSID and specify wireless interface
nmcli -f BSSID,SSID,FREQ,CHAN,RATE,SIGNAL,SECURITY device wifi list ifname <wireless Interface name>

# filter ssid 
nmcli -f BSSID,SSID,CHAN,SIGNAL,SECURITY device wifi list |grep SSID
```

### Rescan SSID
without `rescan` it uses cached results only, which mean the ssid result are all old

- rescan and show all result

```
nmcli dev wifi list --rescan yes
```
`--rescan auto`: default behavior

-	rescan silent : force new scan (will not display scan result)
```
sudo nmcli dev wifi rescan ifname <wireless interface Name>
```
![ssid connected](img/rescan.PNG)

- Rescan 
```
sudo nmcli --fields SSID,BSSID,CHAN,FREQ,SIGNAL,SECURITY dev wifi list --rescan yes | grep -i <SSID>
```
or 
```
sudo nmcli -f SSID,BSSID,CHAN,FREQ,SIGNAL dev wifi list ifname <wireless interface name>
```

### Scan with Low-Level command `iw`
You can also use iw command, which is a low level command which  will show more detail information releated to Wireless interface or SSID information like frequency, signal, ssid, and etc

- Scan SSID with iw command
```
sudo iw dev  <interfaceName>  scan | grep -E "SSID|freq:|channel" | grep -A 2 "<SSIDName>"
```
This will list every frequency where SSID is detected.

- Check connected SSID
```
iw dev <Wireless interface name> link
```

- Filter all SSID with advance command

Scan all ssid 
```
sudo iw dev wlan0 scan | awk '
/SSID:/ {
  ssid=substr($0, index($0,$2))
  print "SSID: " ssid
}'
```


Scan All SSID with specfic field

```
sudo iw dev <interfaceName> scan | awk '
/^BSS/ {bssid=$2}
/freq:/ {freq=$2}
/signal:/ {signal=$2 " " $3}
/SSID:/ {
  ssid=substr($0, index($0,$2))
  print "SSID: " ssid " | BSSID: " bssid " | FREQ: " freq " MHz | SIGNAL: " signal
}'
```

Show connected SSID with specfic field

```
iw dev <wireless interface name> link | awk '
/SSID:/ {ssid=$2}
/freq:/ {freq=$2}
/signal:/ {signal=$2 " " $3}
/rx bitrate:/ {rx=$3 " " $4 " " $5}
/tx bitrate:/ {tx=$3 " " $4 " " $5}
END {
  print "SSID: " ssid " | FREQ: " freq " MHz | SIGNAL: " signal " | RX: " rx " | TX: " tx
}'
```



### Connect SSID

- Connect SSID

> Syntax: `nmcli dev wifi connect "YOUR_WIFI_NAME" password "YOUR_PASSWORD"`

```
example: `nmcli device wifi connect "SSID1" password "1234567890"
```
![ssid connected](img/wifissid_connected.PNG)

you can also use `ask` option for asking password

```
sudo nmcli device wifi connect SSIDNAME --ask
```

- connect SSID with BSSID

```
sudo nmcli dev wifi connect XX:XX:XX:XX:XX:XX password "12345678" ifname <interface name>
```

### Check Status and Full Flow
Now let make a full summary and flow on how we connected, disconnected and check status to see it connected

- Check status
This command will be use often
```
#show all interface link status
nmcli device status
```


- Full Flow

> Step 1: Disconnect the current SSID
```
sudo nmcli device disconnect asus0
```

> Step 2: Scan for the new SSID
```
sudo nmcli dev wifi rescan ifname asus0
```

> Step 3: Connect to the new SSID
```
sudo nmcli dev wifi connect "NEW_SSID" password "PASSWORD" ifname asus0
```


### Save profile 

When you connected SSID actually it's save into profile configure file, which recorded SSID, PSK, and many more SSID information. You can alos use the profile to connected rather than above method. 

> Path location : `ls /etc/NetworkManager/system-connections`

-	Show your profile 

This will only exist if you ever make a connection

```
nmcli connection show
```

or 

```
sudo nmcli connection show "<Profile Name>"
```
If your see duplicate prifile like guest or guest 1, just do like this

```
# single profile
nmcli connection show "gues1"

# duplicate profile
nmcli connection show "guest 1"
```

- Show PSK

```
sudo nmcli connection show ""<Profile Name>" --show-secrets | grep psk
```

-	Connected via profile
Connect with Name
```
sudo nmcli connection up "<name>"
```

Connected with specify interface
```
sudo nmcli connection up "TELUS0886" ifname asus0
```

Enable Auto connection 
```
sudo nmcli connection modify "TELUS0886" connection.autoconnect yes
```

- Modify the profile
```
nmcli -f connection.id,connection.type,connection.interface-name,802-11-wireless.ssid connection show "<profile Name>"
```

Adding psk
```
sudo nmcli connection modify "SSID-guest" wifi-sec.psk "00000000"
```

- Show profile content
```
nmcli connection show "SSID-guest 1"
```

- delete profile
If you change SSID PSK, then the profile needed to clear or delete it. To regenerate it, just spimply use the connect command, no matter success conencted or not it will generate it

Clear
```
#clear it
sudo nmcli connection modify "guest" connection.interface-name ""
#connect it
sudo nmcli connection up "guest" ifname wlan0
```

delte
```
sudo nmcli connection delete "guest"
```

### Check support 6 ghz
In this part will use th elow level wireless command `iw` to see more detail of Wireless HW information


- get  regulatory domain

If you first time use the adapter please check regulatory domain, usullay it set to default. 

```
iw reg get
#filter 6Ghz frequency
iw list | grep -Ei '6 GHz|5955|5975|6115|6435|6875|7115'
```
![6ghz disable](img/default_6ghz.PNG)

In Linux, cfg80211 starts with a highly restrictive world regulatory domain(country 00: DFS-UNSET). If it shows `00`, that is the generic world domain, and 6 GHz often stays unavailable there because Linux begins with restrictive defaults. 

You need to enable it according to which country you're. Each country might support different frequency, so you have to set correct region. 

you can also use the phy to check (`iw dev`) supoort 6ghz
```
iw phy phy4 info | grep -Ei '6 GHz|5955|6115|6435'
```

- enable country code to enable 6Ghz
Let set correct country code and see if it can show 6ghz support 

> set country syntax: `sudo iw reg set <country ex: US, JP, TW..>`

```
sudo iw reg set TW
iw reg get
```
![after set 6ghz country](img/6ghz_enable_country.PNG)

After set country code, you can see it can detect some 6ghz frequency


- Check Support Wifi 7 Frequency 
```
# 6 GHz
iw list | grep -Ei '6 GHz|5955|5975|6115|6435|6875|7115'

# 2.4g and 5G
iw list | grep -Ei '2412|2462|5180|5500|5825'
```

Below is how to detemine which Frequency are 2.4G, 5G and 6GHz

> 2.4 GHz support: frequencies like `2412, 2437, 2462` 
> 5 GHz support: frequencies like `5180, 5200, 5745, 5805 `
> 6 GHz support: frequencies like `5955` and above


-	Check whether it advertises Wi-Fi 7 features

```
iw list | grep -A 20 -E 'EHT|HE|VHT'
```
> VHT = Wi-Fi 5 
> HE = Wi-Fi 6 / 6E (802.11ax = Wi-Fi 6 / 6E capability)
> EHT = Wi-Fi 7 (802.11be = Wi-Fi 7 capability)


- Scan SSID to see 6ghz 
You can scan SSID if DUT support triBand it will show all three band 2.4G, 5G, and 6Ghz, also 6Ghz band security as WPA3

![TriBand Scan result](img/ScanSsid6ghz.PNG)

- reload wireless 
Wi-Fi card is often still running on its old "World Domain" (00) settings. To force the driver to reload the new limits, you should toggle the Wi-Fi off and on:

```
sudo nmcli radio wifi off
sudo nmcli radio wifi on
```

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