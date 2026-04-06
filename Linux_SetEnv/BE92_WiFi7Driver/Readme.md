
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



## Check interface

1. Check wireless interface 
```
sudo apt install -y iw
```
2. Check all interface 

```
ip link show
```

```
ip –br a
```