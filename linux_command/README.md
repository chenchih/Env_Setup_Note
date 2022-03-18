# Some Linux Command
- Check version OS
	>ls_release -a
	
- Check Kernel 
	>uname -a

- check bios version
	>sudo dmidecode -s bios-version

- Shell command
checking current SHELL: `$echo $PATH`
checking support SHELL: `cat /etc/shells` #list all support shell
- bashrc
when adding PATH or ALIAS, need to add in` ~/.bashrc`, else after reboot will return refault


# package 
- uninstall specfic package or services
	>$sudo apt remove <package>
	
	check installed package
	>$sudo apt list -- installed
	
# common use
- mkdir: make directory 
	*I like to use option -vp, -v is verbose which will show message, and p is whether exist or not will create for you*
	>$mkdir -vp directoryname
	
- ln: symbol link
	*This is like a shortcut, it can link file or directory without copying or moving files.*
	>$ln -s /media /test
	>$unlink /test  #remove link test directory
# Storage

- **DD command** (generate file, or convert iso image)
	
	- Create ISO file
		*Create entire usb into iso file*
		> dd if=/dev/sdx of=/path/xxx.iso
	
		*Create iso file to usb*
		> dd if=/path/xxx.iso of=/dev/sdx
	
	- generate file size
	> dd if=/dev/zero of=test.img bs=1024 count=0 seek=1024
	

​		or

> fallocate -l 100M file.txt

- **Check Snart value**
  `$sudo apt-get install smarttcl`
  `$smarttcl -x /dev/sda1`

# copy directory 

- **cp** copy directory *
  `$cp -av source destination`

-  **rsync** can see copy progress
  `$rsync -av --progress source destination`

# SED & AWK
