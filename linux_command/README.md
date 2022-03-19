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

# .bash_aliases (create alias)

**Command:** alias name="your custom command here" Ex:  `alias ip="ip-a"`

- **Method1:**

  `.bashrc` will have default `.bash_aliases` as below

  ```
  if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
  fi
  ```

``` cd ~/
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

**Method 2:** you can edit under `.bashrc`

``` ww
edit in .bashrc the same command as above will work also. 
alias desktop="cd /home/test/Desktop"
```



# Package 

- uninstall specific package or services  PP
	>$sudo apt remove <package>
	>
	>or
	>
	>$sudo apt autoremove  <package> --purge
	
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
