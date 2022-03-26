# Linux Command Note
This will noted linux basic command 
## Basic Linux Command 
### mkdir: make directory
I like to use option `vp`,  `v` is verbose which will show message, and `p`  is whether exist or not will create for you
> $mkdir -vp <directoryname>

## /dev/null error not display
This command is when occur error and wish not to show on script.‵‵example:ls directory 2>/dev/null
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

### ln: symbol link
This is like a shortcut in windows, it can link file or directory without copying or moving files
- link directory 
> $ln -s /media /test
- unlink directory
> $unlink /test  #remove link test directory#  

### cp and rynch
This is copying files or directory, if copy directory need add `-V‵．
- cp (copy comamnd)
`$cp -av <source directory> <destination directory>`

- rsync (copy and show process)
`$rsync -av --progress <source directory> <destination directory>`

## System Version Check  
- Check Linux OS 
> ls_release -a
- Check Kernel version
> uname -av 
- Check bios version   
  > sudo dmidecode -s bios-version
- Check Legacy or UEFI   
  > ls /sys/firmware/efi

	EFI: uefi Mode 
	AHCI: legacy or bios mode 
	
## Shell command
 - checking current SHELL: `$echo $PATH`
 - checking support SHELL: `cat /etc/shells` #list all support shell

##  Alias(custome comamnd line)
What is alias: it's a custome command define by yourself. For example i don't like to use ifconfig, instead i wants to use ip, so i assign like this `alias ip=ifconfig`

> Syntax: alias custom-command=<real command>

In order to add alias, you need to add inside .bashrc, or .bashrc_aliases, if not after reboot will be done. I'm goign to show you two ways:

- **Method 1 (.bash_aliases):**
got to cd ~, and open .bashrc, you will see this script:

  ```
  if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
  fi
  ```
So we need to add `.bash_aliases`, and put our aliases command in it. Full step as below: 
  ```cd
  $cd ~/
  #create .bash_aliases
  $touch .bash_aliases
  #edit the file, and put your command for alias
  alias current-time="echo 'Current time: $(date)'"
  alias desktop="cd /home/test/Desktop"
  
  #run source to enable the alias command
  $source ~/.bash_aliases
  #logout will work
```
  
- ** Methood 2 (edit .bashrc)**
You can also add inside `.bashrc`, but I recommend you use *method 1*. `.bashrc` is system file, if you mess it out, might have problem during boot. You can do like this:
  ```
  #edit in .bashrc the same command as above will work also. 
  alias desktop="cd /home/test/Desktop"
  ```
  
##  Packages
- uninstall specific package 
> $sudo apt remove <package>

	or 
	
	> $sudo apt autoremove  <package> --purge

- check installed package
 > $sudo apt list -- installed

## Extract File
### Tar
- compress:
> tar cvf filename.tar source-folder
- extract: 
> tar -zxvf xxxx.tz.gz

### unzip and zip
- install package:　`$sudo apt-get install zip unzip`
- compress (zip):
>$zip -r file.zip file
- extract (unzip)
>unzip file.zip -d zip_extract

### unrar
- install package:　`$sudo apt-get install unrar`
- compress (zip):
>unrar l filename.rar
- extract (unrar)
>unrar e filename.rar

# Remote Transfer file
### wget
- install package:　`$sudo apt-get install wget`
- download:
>$wget http://XXX.tar.gz

using `-o` parameter to rename file name:
`wget -O namefolder.tar.gz http:/xxxx.tar.gz`

### scp Securely Cop
- install package:　 `sudo apt-get install openssh-server`

	> Syntax: scp -rp filename username(linux)@ip:<destination>
-r: recursive
-p: Preserves modification

Example
  > scp -rp file test@192.168.2.1:/home/test


## dd command 
This comamnd can do generate file, and create usb disk to images 
- Create images to iso
	- Create ISO file:  `dd if=/dev/sdx of=/path/xxx.iso`    
	- Create ISO file to usb: dd if=/path/xxx.iso of=/dev/sdx`
	
- Generate X size file: 
	- dd command: `dd if=/dev/zero of=test.img bs=1024 count=0 seek=1024 ` 
	- fallocate command:  `fallocate -l 100M file.txt`

## Storage Command: 
-  smarttcl: check DISK samrt value or Health 
Check Smart value for HDD
  `$sudo apt-get install smarttcl`
  `$smarttcl -x /dev/sda1` 

##SED and AWK
### SED
This is powerful to do parsing:
- Search and replace string:
>Syntax: sed -i -e 's/<search string> <replace string> /g'

	- Example1: anonymous_enable=NO to anonymous_enable=YES
> sed -i -e 's/anonymous_enable=NO/anonymous_enable=YES/g' /etc/vsftpd.conf
	- Example2: TFTP_DIRECTORY=/srv/tftp into TFTP_DIRECTORY=/tftpboot
``` 
sed -i -e 's/TFTP_DIRECTORY="\/srv\/tftp"/TFTP_DIRECTORY="\'$tftp_dir'"/g' /tftpd-hpa
```

###AWK
- ls directory and get the first string: 
> detectLanint=$(ls /sys/class/net/ |grep en)
ethInt=$(echo $detectLanint |awk '{print $1}')

## EOF and tee 
You can write into a file without vi or echo command. 
- EOF with cat
> Syntax:　cat  << EOF > filename

	Example1:
	> cat << EOF > /etc/samba/smb.conf
	workgroup = WORKGROUP
	EOF

- tee with echo
Example1:
> echo 'network:' | sudo tee /etc/netplan/00-installer-config.yaml
