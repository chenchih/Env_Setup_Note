# Linux Setup and Command Note

# Update setup services:
- [X] vsftp: ftp server
- [X] genieacs: acs server

# Linux Command
I will noted the lunux command often use as a cheatsheet

##  <a id="toc"> Table to content </a>
<details open>
<summary><b>(click to expand or hide)</b></summary>
	
- [1. Basic Command](#basiccommand)
	- [mkdir](#mkdir)
	- [ln](#ln)
	- [cp](#copy)	
- [2. System Version Check](#checkSystem)
	- [check os ver](#checkos)
	- [check Kernel](#checkkernel)
	- [check cpu](#checkcpu)	
	- [check bios](#checkbios)		
- [3. Install Package](#packageInstall)
	- [Remove lock](#Removelock)
	- [Install Package](#package)
- [4. Storage](#storage)
	- [check ssd health: smarttcl](#smarttcl) 
- [5. Network](#network)
	- [netplan set IP address](#netplan)
- [6. System and Path setting](#systempath)
	- [Check current Shell](#shellpath)
	- [Alias](#alias)
- [7. File Extract and Compression](#filecompress)
	- [Tar](#Tar)
	- [unzip and zip](#zip)
	- [unrar](#unrar)
- [8. Remote File transfer](#remotefile)
	- [ wget: download](#wget)
	- [scp: Secure Copy](#scp)
- [9. other advance command](#other)
	- [dd generate to image](#dd)
	- [sed](#sed)
	- [awk](#awk)
	- [EOF and tee](eof)
- [10. Bash Script](#bashscript)


</details>

## <a id="basiccommand"> 1 Basic Command </a> [🔝](#toc)

###  <a id="mkdir"> 1.1 Create directory: `mkdir` </a> 

> Create directory: `mkdir -vp <directoryname>`
>> - `v`:verbose which will show message
>> - `p`:whether exist or not will create for you


###  <a id="ln"> 1.2 symbol link: `ln`  </a>

This is like a shortcut in windows, it can link file or directory without copying or moving files

- link directory 
> `ln -s /media /test`

- unlink directory
> `unlink /test`  #remove link test directory#  

###  <a id="copy"> 1.3 copy file: `cp` and `rynch` </a>

This is copying files or directory, if copy directory need add `-V‵．

- copy comamnd: `cp`
 > `$cp -av <source directory> <destination directory>`

- copy and show process: `rsync`
>  `$rsync -av --progress <source directory> <destination directory>`



## <a id="checkSystem"> 2 System Version Check </a> [🔝](#toc)

### <a id="checkos"> 2.1 Check SW and HW information  </a>

- Check Linux version:  
> - `lsb_release -a`
```
    Distributor ID: Ubuntu
    Description:    Ubuntu 24.04 LTS
    Release:        24.04
    Codename:       noble
```
> - `cat /etc/lsb-release`
> - `cat /etc/*release`
 
###  <a id="checkkernel">  2.2 Check Kernel version </a>
> - `uname -a`
> - `hostnamectl`
    ```
    #uname -a
    Linux chenchih-desktop 6.8.0-1032-raspi #36-Ubuntu SMP PREEMPT_DYNAMIC Mon Jul 21 22:27:49 UTC 2025 aarch64 aarch64 aarch64 GNU/Linux
    #hostnamectl
    Static hostname: chenchih-desktop
       Icon name: computer
      Machine ID: ab31dfdae9ee45e3a10dda9a8d1cde8a
         Boot ID: 5067cf9739c143d9956296b295c66516
    Operating System: Ubuntu 24.04 LTS
          Kernel: Linux 6.8.0-1032-raspi
    Architecture: arm64
    ```

### <a id="checkcpu"> 2.3 Check CPU and MODEL  </a>
- Check CPU 
    > - list cpu infor: `lscpu` 
    ```
Architecture:             aarch64
  CPU op-mode(s):         32-bit, 64-bit
  Byte Order:             Little Endian
CPU(s):                   4
  On-line CPU(s) list:    0-3
Vendor ID:                ARM
  Model name:             Cortex-A76
    ```

- Check model(Only for Rasperaspberrypi): 
> -  `cat /proc/device-tree/model` #Raspberry Pi 5 Model B Rev 1.0c
> - `cat /proc/cpuinfo | grep 'Model'` # Model : Raspberry Pi 5 Model B Rev 1.0

### <a id="checkbios"> 2.4 Check bios version </a>  
>  - Check Legacy or UEFI : `ls /sys/firmware` 
    > - EFI: uefi Mode 
    > - AHCI: legacy or bios mode 



## <a id="packageInstall"> 3. Installation Package </a> [🔝](#toc)

### <a id="Removelock"> 3.1 Remove lock </a>
The lock only allow you to run one process, so need to remove it, else will occur Error not allow to install or update. 

```
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/lib/dpkg/lock
sudo rm /var/cache/apt/archives/lock
sudo dpkg --configure -a
sudo apt update

```


###  <a id="package"> 3.2 Install Packages </a>

- install deb package 
> - using dpg file: `sudo dpkg -i package-name.deb`
> - using apt install dpg file: `sudo apt install ./package-name.deb`


- uninstall specific package 
> - remove: `sudo apt remove  <package>`
> - autoremove: `sudo apt autoremove  <package> --purge`

- check installed package
> - check installed pkg: `sudo apt list -- installed`




## <a id="storage"> 4. Storage Command</a> [🔝](#toc)

### <a id="smarttcl"> smarttcl: check DISK smart value or Health </a>

Please install smarttcl: `sudo apt-get install smarttcl`

> - Check Smart value for HDD: `smarttcl -x /dev/sda1`


## <a id="network"> 5. Network Command</a> [🔝](#toc)

### <a id="netplan"> 5.1  set static or dhcp IP address with netplan </a>

If you are using `2X.04` or above need to change to the netplan command to set the command. 

#### Step1 :  Check you netplan configuration
netplan is been located under `/etc/netplan`, when you access that path, you might have noticed they might occur multiple `.yaml` files. 

> **Problem**: Which one should you edit? please go to the next step to solve this issue. 

```
chenchih@chenchih-desktop:/etc/netplan$ ll
total 28
drwxr-xr-x   2 root root 4096 Aug 28 14:13 ./
drwxr-xr-x 146 root root 8192 Aug 29 06:58 ../
-rw-------   1 root root  422 Aug 28 14:13 50-cloud-init.yaml
-rw-------   1 root root  157 Aug 28 14:07 50-cloud-init.yaml.bk
-rw-------   1 root root  347 Aug 28 13:50 90-NM-626dd384-8b3d-3690-9511-192b2c79b3fd.yaml
-rw-------   1 root root  670 Aug 28 13:28 90-NM-7e43fcda-6dc7-4e7f-be56-bd51225c11e5.yaml
```

#### Step2: Check which YAML file to edit 
Please use this command `nmcli device show | grep IP4.GATEWAY` to know which yaml file we need to edit. If it occur like this:
```
IP4.GATEWAY: --
IP4.GATEWAY: --
IP4.GATEWAY: --
```
nmcli shows all gateways as `--`, meaning NetworkManager isn’t setting a gateway for your NIC (so those `90-NM-*.yaml` files may not actually be in control). That suggests your system is probably using the `50-cloud-init.yaml` file as the active netplan config.

> - `50-cloud-init.yaml` → auto-generated when the system was first installed.
> - `90-NM-xxxx.yaml` → created/managed by NetworkManager (if your system uses it).

#### Step3 check yaml file DHCP SETTING (default)
So let edit this configuration:  `50-cloud-init.yaml`, the default is dhcp, which looks like below:

```
network:
  version: 2
  ethernets:
    eth0:
      match:
        macaddress: "d8:3a:dd:bf:ac:7a"
      dhcp4: true
      dhcp6: true
      set-name: "eth0"

```
#### Step 4 edit yaml file and set the static IP and the default route

I need to change my IP to this setting:
- set ip: 172.21.201.244, 
- default route and gateway:172.21.201.253

```
network:
  version: 2
  ethernets:
    eth0:
      match:
        macaddress: "d8:3a:dd:bf:ac:7a"
      set-name: "eth0"
      dhcp4: false
      dhcp6: false
      addresses:
        - 172.21.201.244/24
      routes:
        - to: default
          via: 172.21.201.253
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]

```

### Step 5 Apply configuration and test it
```
sudo netplan generate
sudo netplan apply
```

- check route: `ip route`

After set default route will occur like below first line occur default
```
default via 172.21.201.253 dev eth0 proto static metric 100
172.21.201.0/24 dev eth0 proto kernel scope link src 172.21.201.244 metric 1
```

-  test by ping
```
ping -c2 8.8.8.8
ping -c2 google.com
```

## <a id="systempath"> 6. System and Path setting  </a> [🔝](#toc)

### <a id="shellpath"> 6.1 Check current Shell  </a>

> - checking current SHELL: `$echo $PATH`
> - checking support SHELL: `cat /etc/shells` #list all support shells


###  <a id="alias">  6.2 Alias (custom command line) </a>

**What is an alias:** It's a custom command defined by yourself. For example, I don't like to use ifconfig, instead I want to use ip, so I assign like this `alias ip=ifconfig`

> Syntax: `alias custom-command=<linux command>`
> ex: `alias ip='ip -a'`

In order to add an alias, you need to add it inside `.bashrc,` or `.bashrc_aliases`, if not after reboot will be done. I'm going to show you two ways:

#### Method 1 (`.bash_aliases`):
  got to `cd` and open `.bashrc`,  you will see script below:
  
  ```
  if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
  fi
  ```
  
  We need to add `.bash_aliases`, and put our aliases command in it. You can follow below step as below: 
  
  ```cd
  $cd ~/
  #create .bash_aliases
  $touch .bash_aliases
  #edit the file, and put your command for alias
  alias current-time="echo 'Current time: $(date)'"
  alias desktop="cd /home/test/Desktop"
  ```
after modify it, you can use `source` to activate else you need to reboot. 

```
  #run source to enable the alias command
  $source ~/.bash_aliases
  #logout will work
```

#### Methood 2 (`.bashrc`)
  You can also add inside `.bashrc`, but I recommend you use *method 1*. `.bashrc` is system file, if you mess it out, might have problem during boot. You can do like this:
  
  ```
  #edit in .bashrc the same command as above will work also. 
  alias desktop="cd /home/test/Desktop"
  source .bashrc
  ```
 
## <a id="filecompress">7. File Extract and Compression  </a> [🔝](#toc)
There are many different compress and extract file type you can use. 

### <a id="Tar"> 7.1 Tar  </a>

- compress:
> `tar cvf filename.tar source-folder`

- extract: 
> `tar -zxvf xxxx.tz.gz`

### <a id="zip"> 7.2 unzip and zip </a>
Please install zip and unzip package:　`$sudo apt-get install zip unzip`

- compress (zip): 
> `zip -r file.zip file`

- extract (unzip)
> `unzip file.zip -d zip_extract`

### <a id="unrar"> 7.3 unrar </a>

Please install zip and unzip package:　`$sudo apt-get install unrar`

- compress (zip):
  
  > `unrar l filename.rar`

- extract (unrar)
  
  > `unrar e filename.rar`


## <a id="remotefile"> 8. Remote File transfer </a> [🔝](#toc)

### <a id="wget"> 8.1 wget: download </a>

Please install wget package:`$sudo apt-get install wget`

- download: `wget http://XXX.tar.gz`
> - `-o` parameter to rename file name:
> - example: `wget -O namefolder.tar.gz http:/xxxx.tar.gz`

### <a id="scp"> 8.2 scp: Secure Copy </a>
Please install openssh-server package `sudo apt-get install openssh-server`
  
> - Syntax: `scp -rp filename username(linux)@ip:<destination>`
>> - `-r`: recursive
>> - `-p`: Preserves modification
  
- Example:
	> - upload: 
	```
	scp /path/file1 myuser@192.168.1.1:/path/file2
	```
	> - download:
	```
	scp myuser@192.168.1.1:/path/file /path/file1
	```
	> - copy directory 
	```
	scp -r /path/folder1 myuser@192.168.0.1:/path/folder2
	```


## <a id="other"> 9. other advance command </a>  [🔝](#toc)

### <a id="dd"> 9.1 dd generate to image </a>

This comamnd can do generate file, and create usb disk to images 

> - Create images to iso:
    > Create ISO file:  `dd if=/dev/sdx of=/path/xxx.iso`    
    > Create ISO file to usb: `dd if=/path/xxx.iso of=/dev/sdx`

> - Generate X size file: 
    > - dd command: `dd if=/dev/zero of=test.img bs=1024 count=0 seek=1024` 
    > - fallocate command:  `fallocate -l 100M file.txt`
	
### <a id="sed"> 9.2 SED </a>

This is powerful to do parsing:

- Search and replace string:
> Syntax: `sed -i -e 's/<search string> <replace string> /g'`

    - **Example1**: anonymous_enable=NO to anonymous_enable=YES
    ```
    sed -i -e 's/anonymous_enable=NO/anonymous_enable=YES/g' /etc/vsftpd.conf
    ```
  
    - **Example2**: TFTP_DIRECTORY=/srv/tftp into TFTP_DIRECTORY=/tftpboot
    ```
    sed -i -e 's/TFTP_DIRECTORY="\/srv\/tftp"/TFTP_DIRECTORY="\'$tftp_dir'"/g' /tftpd-hpa
    ```

### <a id="awk"> 9.3 AWK  </a>
- ls directory and get the first string: 
  > - `detectLanint=$(ls /sys/class/net/ |grep en)`
  > - `ethInt=$(echo $detectLanint |awk '{print $1}')`

### <a id="eof"> 9.4 EOF and tee </a>

You can write into a file without vi or echo command. 

- EOF with `cat` example
  > Syntax:　`cat  << EOF > filename`
    ```
    cat << EOF > /etc/samba/smb.conf
    workgroup = WORKGROUP
    EOF
    ```
- tee with `echo`
> `echo 'network:' | sudo tee /etc/netplan/00-installer-config.yaml`


## <a id="bashscript"> 10. Bash Script </a> [🔝](#toc)

### error not display: `/dev/null`

This command is when occur error and wish not to show on script, for example:`ls directory 2>/dev/null`

```
#iso file not found
findiso=$(ls $isoname 2>/dev/null )
if [[ $findiso == *.iso ]] ; then
    :
else
    #echo $0>>/dev/null            
    read -p "file not exist !!!! please try again. Press any key to continue"       
fi
```




