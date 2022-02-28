#!/bin/bash
#####################################################################
function install_package_dhcpd(){
apt-get update 
echo "#####Install SMB, DHCP, tftp, vsftpd,apache2, vsftpd, apache2####" 
apt-get install samba isc-dhcp-server tftpd-hpa vsftpd  apache2 nfs-kernel-server -y
echo "all package update and install complete"
echo "Install syslinux"
apt-get install syslinux-common syslinux-efi pxelinux -y
#apt-get install grub-efi-amd64-signed shim-signed -y
echo "#####syslinux, syslinux-efi and pxelinux install complete#####"

}

function install_package_dnsmasq(){
echo "#####Install SMB,vsftpd,apache2, vsftpd, apache2####" 
apt-get clean
apt-get update && apt-get install -y dnsmasq nfs-kernel-server vsftpd apache2 samba
echo "all package update and install complete"
echo "Install syslinux"
apt-get install syslinux-common syslinux-efi pxelinux -y
#apt-get install grub-efi-amd64-signed shim-signed -y
echo "#####syslinux, syslinux-efi and pxelinux install complete#####"

}

#####################################################################
function backupfile(){
	findfiletype=$(ls |grep $filename.bk)
	#if [[ $findfiletype == *.bk ]] ; then
	echo $filename
	#if [[ $filename == $filename.bk ]] ; then
	if [[ $findfiletype == $filename.bk ]] ; then
	    echo 'file exist'
	    :
	else
	    echo 'no bk file, creating backup file for '$filename   
	    cp "$filename" "$filename".bk
	    #cp /etc/default/tftp-hpa /etc/default/tftp-hpa.bk
	fi
}
####################################TFTP################################################################################
function tftp_config(){

	# setup tftp directory
	echo "creating tftpboot directory"
	#mkdir -pv /tftpboot/BIOS{pxelinux.cfg,images/{centos,ubuntu,windows},kernels/{centos,ubuntu},efi/pxelinux.cfg}
	mkdir -pv $tftp_dir/{BIOS,pxelinux.cfg,images/{windows},kernels,UEFI}
	chmod 777 -R $tftp_dir
	# setup tftp configure
	echo "Start configure tftpd setting"
	###############Backup files############
	path="/etc/default/"
	filename="tftpd-hpa"
	cd $path 
	echo "check and backup tftpd config"
	backupfile $filename
	#sed -i -e 's/TFTP_DIRECTORY="\/srv\/tftp"/TFTP_DIRECTORY="\/tftpboot"/g' /etc/default/tftpd-hpa
	sed -i -e 's/TFTP_DIRECTORY="\/srv\/tftp"/TFTP_DIRECTORY="\$tftp_dir"/g' /etc/default/tftpd-hpa
	echo "RUN_DAEMON="yes"" >> /etc/default/tftpd-hpa
	echo 'OPTIONS="-l -s /tftpboot"' >> /etc/default/tftpd-hpa
	echo "restart tftpd server"
	systemctl restart tftpd-hpa
	echo "check tftpd status"
	systemctl status tftpd-hpa
	echo "tftp conf setting done"
}


#####################################FTP#################################################################
function vsftp_config(){

	# setup ftp directory
	echo "creating pub directory"
	cd /srv/ftp/
	mkdir -pv pub
	chmod 777 -R /srv/ftp/pub
	
	# setup ftp configure
	echo "Start configure vsftpd setting"
	path="/etc"
	filename="vsftpd.conf"
	cd $path
	
	###############Backup files############
	echo "check and backup vsftpd config"
	backupfile $filename
	echo "set anonymous_enable"
	sed -i -e 's/anonymous_enable=NO/anonymous_enable=YES/g' /etc/vsftpd.conf
	echo "restart vsftpd"
	systemctl restart vsftpd
	systemctl enable vsftpd
	echo "check vsftpd status"
	systemctl status vsftpd
	echo "vsftp conf setting done"
}
######################################################samba##############################################################
function smb_config(){
echo "Start configure smb setting"
path="/etc/samba/"
filename="smb.conf"
cd $path
###############Backup files############
echo "check and backup smb config"
backupfile $filename
echo "writting file into smb.conf"
cat << EOF > /etc/samba/smb.conf
[global]
workgroup = WORKGROUP
map to guest = bad user
usershare allow guests = yes
[windows]
browsable = true
read only = yes
guest ok = yes
path = /tftpboot/images/windows
EOF
echo "restart smbd"
systemctl restart smbd
systemctl enable smbd
echo "check smbd status"
systemctl status smbd
echo "smbd conf setting done"	
}

###############################################DHCPD#####################################################################

function dhcp_setting(){
echo "set dhcp setting"
path="/etc/dhcp/"
filename="dhcpd.conf"
cd $path
echo $filename
###############Backup files############
echo "backup dhcp config"
backupfile $filename
echo "writting file into dhcpd.conf"
cat << EOF > /etc/dhcp/dhcpd.conf
ddns-update-style none;
default-lease-time 43200;
max-lease-time 86400;
option arch code 93 = unsigned integer 16; # RFC4578
subnet 192.168.2.0 netmask 255.255.255.0 {
#option routers 192.168.2.1;
option routers $staticIP;
option broadcast-address 192.168.2.255;
range 192.168.2.2 192.168.2.200;
#range dynamic-bootp 192.168.2.2 192.168.2.254;
next-server 192.168.2.1;
if option arch = 00:07 or option arch = 00:09 {
   filename "efi/syslinux.efi";
}
#arm platform
else if option arch = 00:0b {
  filename "/EFI/aarch64/bootaa64.efi";
 }
 else  {
   filename "pxelinux.0";
 }

}
EOF

echo "restart dhcp"
systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server
echo "check isc-dhcp-server status"
systemctl status isc-dhcp-server
echo "isc-dhcp-serversetting DONE"

}
#========================configure DNSmasq ================================================
function dnsmasq(){

# create tftpboot directory
echo "creating tftpboot directory"
mkdir -pv $tftp_dir/{BIOS,pxelinux.cfg,images/{windows},kernels,UEFI}
chmod 777 -R $tftp_dir
	
echo "Start configure dnsmasq"
path="/etc"
filename="dnsmasq.conf"
cd $path 	
backupfile $filename
echo "backup dnsmasq"
#cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
cat << EOF > /etc/dnsmasq.conf

interface=$ethInt
bind-interfaces
domain=koti.local
 
#dhcp-range=ens33,192.168.100.100,192.168.100.240,255.255.255.0,8h
dhcp-range=$ethInt,192.168.2.2,192.168.2.254,255.255.255.0,8h
dhcp-option=option:router,$staticIP
dhcp-option=option:dns-server,$staticIP
dhcp-option=option:dns-server,8.8.8.8
 
enable-tftp
#tftp-root=/netboot/tftp
tftp-root=$tftp_dir
#dhcp-boot=pxelinux.0,linuxhint-s20,192.168.2.1
dhcp-boot=pxelinux.0
pxe-prompt="Press F8 for PXE Network boot.", 2
#pxe-service=x86PC, "Install OS via PXE",pxelinux
#pxe-service=X86-64_EFI, "Boot UEFI PXE-64", efi/syslinux.efi

# PXEClient:Arch:00000
pxe-service=X86PC, "Boot BIOS PXE", BIOS/pxelinux

# PXEClient:Arch:00007
pxe-service=BC_EFI, "Boot UEFI PXE-BC", UEFI/syslinux.efi

# PXEClient:Arch:00009
pxe-service=X86-64_EFI, "Boot UEFI PXE-64", UEFI/syslinux.efi
EOF


}
################################################

function assing_interface(){
#ethInt=$(ip addr show | awk '/inet.*brd/{print $NF; exit}')
echo "set network interface: "$ethInt
sudo sed -i -e 's/INTERFACESv4=""/INTERFACESv4="'"$ethInt"'"/g' /etc/default/isc-dhcp-server
echo "DHCP interface add DONE"
}

################################################
function staticIP_setting() {

###############Backup files############
# ethInt=$(ip addr show | awk '/inet.*brd/{print $NF; exit}')
echo "backup netplan network config"
cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bk
echo "writting file into XXX.yaml"
cat << EOF > /etc/netplan/00-installer-config.yaml
network:
  version: 2
  #renderer: networkd
  renderer: NetworkManager
  ethernets:
    #enp4s0:
    $ethInt:
      dhcp4: no
      addresses:
        #- 192.168.2.1/24  
        - $staticIP/24      
      gateway4: 192.168.2.254
EOF
echo "Finsih writting file into XXX.yaml"
echo "apply and try"
netplan apply
#netplan try
echo "Static IP set DONE"
}

#=====================PXE_confiigure files=====================
#NEED TO MODIFY
function PXE_configure(){

#link syslinux and pxelinux related files 
echo "copy pxelinux and other - files to tftp folder"
#BIOS PXE file
#cd /tftpboot/BIOS
#ln -s /usr/lib/PXELINUX/pxelinux.0 .
#ln -s /usr/lib/syslinux/modules/bios/{ldlinux,menu,libcom32,libutil,vesamenu}.c32  .
#ln -s /usr/lib/syslinux/memdisk .
echo "====copy bios pxe file===="
cp -av /usr/lib/PXELINUX/pxelinux.0 $tftp_dir/BIOS
cp -av /usr/lib/syslinux/modules/bios/{ldlinux.c32,libcom32.c32,libutil.c32,vesamenu.c32} $tftp_dir/BIOS
#UEFI PXEFILE

#cd /tftpboot/uefi/
#cp /usr/lib/shim/shim.efi.signed /tftpboot/bootx64.efi
#ln -s /usr/lib/syslinux/modules/efi64/{ldlinux,menu,libcom32,libutil,vesamenu}.c32 .
#ln -s /usr/lib/syslinux/memdisk 
echo "====copy UEFI pxe file===="
cp -av /usr/lib/syslinux/modules/efi64/{ldlinux.e64,libcom32.c32,libutil.c32,vesamenu.c32} $tftp_dir/UEFI
cp -av /usr/lib/SYSLINUX.EFI/efi64/syslinux.efi $tftp_dir/UEFI

echo "====copy memdisk into kernels===="
cp -av /usr/lib/syslinux/memdisk  $tftp_dir/kernels

echo "====link pxelinux.cfg and kernel ===="
ln -s $tftp_dir/pxelinux.cfg $tftp_dir/BIOS && ln -s $tftp_dir/pxelinux.cfg $tftp_dir/UEFI
ln -s $tftp_dir/kernels $tftp_dir/BIOS && ln -s $tftp_dir/kernels $tftp_dir/UEFI

#ln -s /tftpboot/kernels /tftpboot/BIOS && ln -s /tftpboot/kernels /tftpboot/uefi
#ln -s $tftp_dir/kernels $tftp_dir/BIOS && ln -s $tftp_dir/kernels $tftp_dir/UEFI
echo "PXE_confiigure files DONE"
}

#=====================pxemenuadd default =====================
function pxe_menu_default(){
echo "create pxe menu"
cd $tftp_dir/pxelinux.cfg
touch default 
cat << EOF > $tftp_dir/pxelinux.cfg/default
prompt 0
timeout 300
ONTIMEOUT local
default vesamenu.c32
#MENU PXE OS Installation 
MENU TITLE ---------- PXE Boot Menu ----------

LABEL local
    MENU DEFAULT                            
    #MENU HIDE                             
    MENU LABEL Boot from ^local drive
    localboot 0
	
LABEL centos7_x64
 MENU LABEL CentOS 7 X64 http
 KERNEL kernels/centos7/vmlinuz
 APPEND initrd=kernels/centos7/initrd.img  inst.repo=http://$serverIP/images/centos7  ks=http://$serverIP/ks.cfg" keymap=us lang=en_US ip=dhcp

LABEL centos7_x64
 MENU LABEL CentOS 7 X64 nfs
 KERNEL kernels/centos7/vmlinuz
 APPEND initrd=/kernels/centos7/initrd.img  method=nfs:$serverIP/images/centos7  ks=http://$serverIP/ks.cfg keymap=us lang=en_US ip=dhcp

label Ubuntu 20.04 LTS Desktop NFS Manual
  menu label ^Install Ubuntu 20.04 LTS Desktop NFS manual installation
  kernel kernels/ubuntu2004/linuz 
  append initrd=kernels/ubuntu2004/initrd nfsroot=$serverIP:$tftp_dir/images/ubuntu2004 ro netboot=nfs boot=casper ip=dhcp --
  
label Ubuntu 20.04 LTS Desktop NFS Automatic 
menu label ^Install Ubuntu 20.04 LTS Desktop NFS automatic install 
menu default
kernel  kernels/ubuntu2004/vmlinuz 
initrd  kernels/ubuntu2004/initrd 
append ip=dhcp netboot=nfs automatic-ubiquity boot=casper nfsroot=$serverIP:$tftp_dir/images/ubuntu2004 auto=true url=http://$serverIP/local-sources.seed splash toram ---  

LABEL  winpe 
MENU LABEL windowPE for window 10
KERNEL     /kernels/memdisk
INITRD     /images/windows/winpe_amd64.iso
APPEND     iso raw
EOF

echo "creating  pxe menu complete"
}

#=====================pxemenuadd user enter=====================
function pxe_menuadd_userinput(){
clear
cat << EOF > $tftp_dir/pxelinux.cfg/default
DEFAULT local
UI menu.c32
PROMPT 1
TIMEOUT 60
LABEL local
localboot 0

EOF

while :
do
	echo "#########SCRIPT Adding PXEMENU MAIN ##################"	
	#read -p "OS type: 1for ubuntu,2 for centos/RHEL/AlmaLinux)q to exit) " pxeostype
	echo -e "Please select OS type\n 1.Ubuntu \n 2.centos/RHEL/AlmaLinux \n 3.window \n q. to exit"
	echo "###########################"	
        read -p "options:" pxeostype
	if [ "$pxeostype" == "1" ];then 
		read -p "os menu name: " osmenuname
		read -p "kernels path:(/kernels/x): " kernelpath
		read -p "image download method(nfs/http/ftp): " downtype
		
			if [ "$downtype" == "nfs" ];then
				read -p "image path location (ex: /tftpboot/images/X):" imagepath
				echo "label install $osmenuname" >> $tftp_dir/pxelinux.cfg/default
  				echo "menu label ^Install $osmenuname">> $tftp_dir/pxelinux.cfg/default
  				echo "kernel /kernels/$kernelpath/linuz" >> $tftp_dir/pxelinux.cfg/default
 				echo "append initrd=/kernels/$kernelpath/initrd nfsroot=$serverIP:/tftpboot/$imagepath ro netboot=nfs boot=casper ip=dhcp --" >> /tftpboot/pxelinux.cfg/default
 				echo "">> $tftp_dir/pxelinux.cfg/default
 				read -p "please enter to continue"
 				clear
						
			elif  [ "$downtype" == "http" ];then 
				read -p "images iso name (ISO)(/tftpboot/images/XXX.iso): " imagepath
				echo "label install $osmenuname" >> $tftp_dir/pxelinux.cfg/default
  				echo "menu label ^Install $osmenuname">> $tftp_dir/pxelinux.cfg/default
  				echo "kernel /kernels/$kernelpath/linuz" >> $tftp_dir/pxelinux.cfg/default
 				echo "append initrd=/kernels/$kernelpath/initrd url=http://$serverIP/$imagepath  ip=dhcp --" >> /tftpboot/pxelinux.cfg/default	
				echo "">> $tftp_dir/pxelinux.cfg/default
 				read -p "please enter to continue"	
 				clear
 			
 					
			elif  [ "$downtype" == "ftp" ];then 
				read -p "images iso name(ISO)(/tftpboot/images/ubuntu/XXX.iso) " imagepath
				echo "label install $osmenuname" >> $tftp_dir/pxelinux.cfg/default
  				echo "menu label ^Install $osmenuname">> $tftp_dir/pxelinux.cfg/default
  				echo "kernel /kernels/$kernelpath/linuz" >> $tftp_dir/pxelinux.cfg/default
 				echo "append initrd=/kernels/$kernelpath/initrd url=ftp://$serverIP/$imagepath  ip=dhcp --" >> /tftpboot/pxelinux.cfg/default		
 				echo "">> $tftp_dir/pxelinux.cfg/default
 				read -p "please enter to continue"	
 				clear	
			else
				echo "no option"
				read -p "please enter to continue"	
 				clear	
			fi
	elif  [ "$pxeostype" == "2" ];then 
		read -p "os menu name: " osmenuname
		read -p "kernel path:(/kernels/x, ex:x=ubuntuxx):" kernelpath
		read -p "image download method(nfs/http/ftp): " downtype
		read -p "image path location (ex: /tftpboot/images/X): " imagepath
			if [ "$downtype" == "nfs" ];then	
				echo "label install $osmenuname" >> $tftp_dir/pxelinux.cfg/default
  				echo "menu label ^Install $osmenuname">> $tftp_dir/pxelinux.cfg/default
  				echo "kernel /kernels/$kernelpath/vmlinuz" >> $tftp_dir/pxelinux.cfg/default
 				echo "append initrd=/kernels/$kernelpath/initrd.img method=nfs:$serverIP/$imagepath  ks=http://$serverIP/ks.cfg" keymap=us lang=en_US ip=dhcp>> /tftpboot/pxelinux.cfg/default			
 				echo "">> $tftp_dir/pxelinux.cfg/default	
 				read -p "please enter to continue"					
 				clear	
			elif  [ "$downtype" == "http" ];then 
				echo "label install $osmenuname" >> $tftp_dir/pxelinux.cfg/default
  				echo "menu label ^Install $osmenuname">> $tftp_dir/pxelinux.cfg/default
  				echo "kernel /kernels/$kernelpath/vmlinuz" >> $tftp_dir/pxelinux.cfg/default
 				echo "append initrd=/kernels/$kernelpath/initrd.img method=http://$serverIP/$imagepath  ks=http://$serverIP/ks.cfg" >> /tftpboot/pxelinux.cfg/default
 				echo "">> $tftp_dir/pxelinux.cfg/default
 				read -p "please enter to continue"
 				clear

			elif  [ "$downtype" == "ftp" ];then 
				echo "label install $osmenuname" >> $tftp_dir/pxelinux.cfg/default
  				echo "menu label ^Install $osmenuname">> $tftp_dir/pxelinux.cfg/default
  				echo "kernels /kernels/$kernelpath/vmlinuz" >> $tftp_dir/pxelinux.cfg/default
 				echo "append initrd=/kernels/$kernelpath/initrd.img method=ftp://$serverIP/$imagepath  ks=http://$serverIP/ks.cfg" >> /tftpboot/pxelinux.cfg/default
 				echo "" >> $tftp_dir/pxelinux.cfg/default
 				read -p "please enter to contiue"
 				clear		
			
			else
				echo "no option"
				read -p "please enter to contiue"
				clear
			fi
	elif [ "$pxeostype" == "3" ];then	
		read -p "os menu name: " osmenuname	
		read -p "image WINPE iso location (ex:/images/windows/winpe_amd64.iso): " imagepath
		echo "LABEL  $osmenuname" >> $tftp_dir/pxelinux.cfg/default
		#MENU LABEL window10
		echo "MENU LABEL $osmenuname" >> $tftp_dir/pxelinux.cfg/default
		echo "KERNEL     /kernels/memdisk" >> $tftp_dir/pxelinux.cfg/default	
		echo "INITRD     /$imagepath" >> $tftp_dir/pxelinux.cfg/default
		echo "APPEND     iso raw" >> $tftp_dir/pxelinux.cfg/default
		echo "" >> $tftp_dir/pxelinux.cfg/default
		read -p "please enter to continue"
		clear	
		
	elif [ "$pxeostype" == "q" ];then 
		#read -p "please enter to exit"	
		break
		#clear		
		#exit
		
	else
		echo -e "no options found, please enter to retry"
		clear
		#break		
fi
done
}

function  checkisofilexist(){
findiso=$(ls $isoname 2>/dev/null )

#echo "iso name find" $findfiletype
	if [[ $findiso == *.iso ]] ; then
	#if [[ -e $findfiletype ]] ; then
	    #echo 'file exist'
	    :
	else
	    #echo $0>>/dev/null		    
	    read -p "file not exist !!!! please try again. Press any key to continue"	   
	    pxeimages
	    #break
	fi
}
########################CREATING os IMAGE ######################################################
function pxeimages(){
clear
while :
do
	echo "###########################"	
	echo -e "Please select \n 1.Images \n 2.kernel \n 3.Both \n q. to exit"
	echo "###########################"	
        read -p "options:" imagemenu      
        
	if [ "$imagemenu" == "1" ];then 
		read -p "iso full path(ex /centos.iso): " isoname
		checkisofilexist		
		read -p "Save your image location: Ex:/tftpboot/images/X:" imagedirname		
		mkdir -p $tftp_dir/images/$imagedirname		
		mount -o loop $isoname /mnt	
       	rsync  -av --progress /mnt/. $tftp_dir/images/$imagedirname/		
       	umount /mnt
       	read -p "Copy to images file complete. Please enter to coniue"
 		clear
						
	elif  [ "$imagemenu" == "2" ];then 
		clear
		echo "###########################"
		echo -e "Please enter os type \n1.Ubuntu \n2.CentOS RHEL Fedora \nq quit "
		echo "###########################"
		read -p "Options: " isotype
			if [ "$isotype" == "1" ];then	
				read -p "iso full path(ex /ubuntu.iso): " isoname	
				checkisofilexist	
				read -p "Save your kernel location(Ex:/tftpboot/kernels/X ): " kerneldirname				
				mkdir -p $tftp_dir/kernels/$kerneldirname
				chmod 777 -R $tftp_dir/kernels/$kerneldirname										
				mount -o loop $isoname /mnt			
				cp -av /mnt/casper/{initrd,vmlinuz} $tftp_dir/kernels/$kerneldirname
 				umount /mnt
 				read -p "Copy to kernel file complete. Please enter to coniue"
 				clear
			elif [ "$isotype" == "2" ];then
				read -p "iso full path(ex /centos.iso): " isoname	
				checkisofilexist	
				read -p "Save your kernel location(Ex:/tftpboot/kernels/X ):" kerneldirname				
				mkdir -pv $tftp_dir/kernels/$kerneldirname
				chmod 777 -R $tftp_dir/kernels/$kerneldirname	
				mount -o loop $isoname /mnt									
				cp -av /mnt/isolinux/{initrd.img,vmlinuz} $tftp_dir/kernels/$kerneldirname
 				umount /mnt
 				read -p "Copy to kernel file complete. Please enter to coniue"
 				clear			
			else
				read -p "no OS TYPE option please enter to try again "	
 				clear	
			fi
			
	elif  [ "$imagemenu" == "3" ];then 
		#clear
		read -p "iso full path(ex /centos.iso): " isoname
		checkisofilexist				
		read -p "Save your image and kernels dir name: Ex:/tftpboot/images/X:" imagedirname	
		read -p "Save your kernel location(Ex:/tftpboot/kernels/X ):" kerneldirname	
		echo "###########################"	
		echo -e "Please enter os kernel type \n1.Ubuntu \n2.CentOS RHEL Fedora \nq quit "
		echo "###########################"			
		read -p "Options: " isotype		
		
		mkdir -pv $tftp_dir/images/$imagedirname	
		mkdir -pv $tftp_dir/kernels/$kerneldirname		
		mount -o loop $isoname /mnt	
       	rsync  -av --progress /mnt/. $tftp_dir/images/$imagedirname/	
		read -p "Copy images success. Please enter to contiue"			
		if [ "$isotype" == "1" ];then	
			cp -av /mnt/casper/{initrd,vmlinuz} $tftp_dir/kernels/$kerneldirname
			
		elif [ "$isotype" == "2" ];then
			cp -av /mnt/isolinux/{initrd.img,vmlinuz} $tftp_dir/kernels/$kerneldirname		
		else
			read -p "no option please enter to try again "	
 			clear	
		clear	
		umount /mnt			
		read -p "Copy kernel complete. Please enter to contiue"		
		fi
	elif [ "$imagemenu" == "q" ];then 
		#read -p "please enter to exit"	
		break
		#clear		
		#exit	
	else
		echo -e "no options found, maybe you type wrong. Please enter to retry again"
		clear
		#break		
fi
done
}

#=====================pxemenuadd user enter main =====================
function pxemenuadd_menumain(){
#serverIP=192.168.2.1
#tftpdir="/tftpboot"
while :
do
	echo "###########################"
	echo "1)Add your Menu: "
	echo "2)Set your information IP and tftp location: "
	echo "3)Default IP and tftp: "
	echo "q to exit: "
	echo "###########################"
	read -p "Your Options: " option
	
	if [ "$option" == 1 ];then   				
		echo -e "IP:"$serverIP "\nlocation:"$tftpdir
		pxemenuadd
		read -p "please enter to continue"
		clear

	elif [ "$option" == 2 ];then   
		setvalue		
		echo -e "IP:"$serverIP "\nlocation:"$tftpdir
		read -p "please enter to continue"
		clear

	elif [ "$option" ==  3 ];then   			
		echo -e "IP:"$serverIP "\nlocation:"$tftpdir
		read -p "please enter to continue"
		clear
		
	
	elif [ "$option" == "q" ];then   
		read -p "please enter to exit"
		clear
		break
		
	else
		echo -e "no options found, please enter to retry"
		clear
		#break	

fi
done
}

#=====================main =====================
function main_menu(){
while :
do
	echo "########SCRIPT Main MENU###################"
	echo "1)[setup] pxe (DHCPD tftpd) "
	echo "2)[setup] pxe (dnsmasq)  "
	echo "3)PXE MENU manual set"
	echo "4)PXE MENU use default"
	echo "5)Adding images to tftpboot folder:"
	echo "6)Automatic setup pxe and menu:"
	echo "7)See default Lan IP/Interface, and tftp:"	
	echo "8)Set IP and TFTP dir: "
	echo "q to exit: "
	echo "###########################"
	read -p "Please enter your Options: " option

	if [ "$option" == 1 ];then   		
		install_package_dhcpd		
		tftp_config
		vsftp_config
		smb_config
		PXE_confiigure
		#pxe_menu_default
		assing_interface
		staticIP_setting
		dhcp_setting
		#tfp
		echo "restart tftpd"
		systemctl restart tftpd-hpa
		systemctl status tftpd-hpa
		#dhcp
		echo "restart isc-dhcp-server "
		systemctl restart isc-dhcp-server
		systemctl status isc-dhcp-server
		#ftp
		echo "restart vsftps"
		systemctl restart vsftpd
		systemctl status vsftpd
		#samba
		echo "restart smbd"
		systemctl restart smbd
		systemctl status smbd
		#http
		echo "restart apache2"
		systemctl restart apache2
		systemctl status apache2
		#nfs
		echo "restart nfs"
		systemctl restart nfs-kernel-server
		systemctl status nfs-kernel-server	
		read -p "please enter to continue"		
		
	elif [ "$option" == 2 ];then 		
		install_package_dnsmasq		
		staticIP_setting		
		dnsmasq
		vsftp_config
		smb_config		
		PXE_confiigure
		#pxe_menu_default
		#ftp
		echo "restart vsftps"
		systemctl restart vsftpd
		systemctl status vsftpd
		#samba
		echo "restart smbd"
		systemctl restart smbd
		systemctl status smbd
		#http
		echo "restart apache2"
		systemctl restart apache2
		systemctl status apache2
		#nfs
		echo "restart nfs"
		systemctl restart nfs-kernel-server
		systemctl status nfs-kernel-server	
		#dnsmasq
		echo "restart nfs"
		systemctl restart dnsmasq
		systemctl status dnsmasq			
		
		read -p "please enter to continue"
		clear
		
	elif [ "$option" == 3 ];then   
		pxe_menuadd_userinput			
		read -p "please enter to continue"
		clear
	elif [ "$option" == 4 ];then   
		pxe_menu_default	
		read -p "please enter to continue"
		clear
	elif [ "$option" ==  5 ];then   			
		pxeimages
		read -p "please enter to continue"
		clear	
	#automatic run script	
	elif [ "$option" ==  6 ];then   			
		auto
		read -p "please enter to continue"
		clear	

	#print default setting
	elif [ "$option" ==  7 ];then   			
		echo -e "IP: $staticIP \nTFTP Path: $tftp_dir \nLan Interface: $ethInt"	
		read -p "please enter to continue"		
		clear
	elif [ "$option" == 8 ];then   
		#setvalue
		setingconfig	
		read -p "please enter to continue"
		clear	
	elif [ "$option" == "q" ];then   
#		echo "no options"
		read -p "please enter to exit"
		exit
		clear
#		break
	else
		echo -e "no options found, please enter to retry"
		#break

fi
done
}

#========================configure nfs_setting ========================
function nfs_setting(){
read -p "enter your tftp diretory or sharing directory (EX:/tftboot): "tftpdir 
#echo "/tftpboot/  192.168.2.0/24(ro,no_root_squash,no_subtree_check)" >> /etc/exports
echo "writting file into exports"
echo "$tftpdir 192.168.2.0/24(ro,no_root_squash,no_subtree_check)" >> /etc/exports
echo "start exportfs"
exportfs -av
echo "nfs setting DONE"
}


#========================nterface and ip address ========================[DONE]
function setingconfig(){
read -p "set static Lan interface(empty for default interface): " Interfaceset
if [[ -z "$Interfaceset" ]]
then
    ethInt=$(ls /sys/class/net/ |grep enp)
    #echo "null"    
else
    #echo "not null"
    ethInt=$Interfaceset 
fi

read -p "set static IP (empty for default IP addr): "IPaddset
if [[ -z "$IPaddset" ]]
then
    #staticIP=192.168.2.1
    staticIP=192.168.2.1
    #echo "null"     
else
    #echo "not null"
    staticIP=$IPaddset  
fi

read -p "set tftp Location (empty for default tftp directory): "tftp_dir
if [[ -z "$tftp_dir" ]]
then
    #staticIP=192.168.2.1
    tftp_dir="/tftpboot"
    #echo "null" 
    
else
    #echo "not null"
    tftp_dir=$tftp_dir  
fi

echo "IP addr setting DONE"
echo "TFTP dir setting DONE"
echo "Network interface setting DONE"
}

function auto(){
install_package_dhcpd
assing_interface
dhcp_setting
install_package_dnsmasq
staticIP_setting
tftp_config
vsftp_config
smb_config
PXE_confiigure
pxe_menu_default
} 

#########################################################################
ethInt=$(ls /sys/class/net/ |grep en)
staticIP=192.168.2.1
tftp_dir="/tftpboot"
serverIP=$staticIP
#echo "staticIP $staticIP serverIP $serverIP"
main_menu
#pxe_menu
#########################################################################

