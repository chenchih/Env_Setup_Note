########################PXE SCRIPT SETUP FOR RHEL/CENTOS7 ABOVE#####################
###########Revision 1: 20160408#############################################
###########Revision 2: 20160410 Finsihed Final#############################################
########################DATE RELEASE: 2016/04/06####################################
function PXE_SETUP(){
echo "1=>Please Enter Related Information: "
echo -n "Please Enter IP interface (EX: eth0 /em0):"
read interface_ip
echo -n "Please Enter IP add (EXL 192.168.X.X) :"
read ipadd_int
ipaddr1=192.168.$ipadd_int
echo "=========End Enter Infomration============ "
echo ""
echo "2=>Extract PXE_FILE "
tar zxvf PXE_FILE_2016.tar.gz
echo "=========End Extract File============ "

#####################LAN SETTING ########################################
echo "3=>Set Up Lan Address "

cp /PXE_FILE/ifcfg-xxx /PXE_FILE/ifcfg-xxx.bk
mv /PXE_FILE/ifcfg-xxx /etc/sysconfig/network-scripts/ifcfg-"$interface_ip"
sed -i "11c IPADDR=$ipaddr1" /etc/sysconfig/network-scripts/ifcfg-"$interface_ip"
sed -i "9c NAME=$interface_ip" /etc/sysconfig/network-scripts/ifcfg-"$interface_ip"
service network restart
echo "=========Finish Set Lan Address============ "
echo ""

########################Set local repos ######################
echo "4-1=>Set up repostory to install package "
echo "Check to see /dvd exist or not, if not create it"
umount -a
clear
if [ ! -d /dvd ]; then
  # if dvd not exist create it
mkdir /dvd
fi
echo "mount cdrom"
echo ""
mount /dev/cdrom /dvd
echo ""
echo "Go to /etc/yum/repos and create a new repos file"
mkdir -p /etc/yum.repos.d/other
#shopt -s extglob
#cd /etc/yum.repos.d/
#shopt -s extglob
#mv "/etc/yum.repos.d"/!(other) /etc/yum.repos.d/other
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/other
cp /PXE_FILE/test.repo /etc/yum.repos.d/
yum clean all
echo "==============finsihed setup repostory============="
clear
########################Set local repos and install package######################
echo "4-2=>Install package "
echo "Install dhcp"
yum -y install dhcp
echo "Install xinetd"
yum -y install xinetd
echo "Install tftp-server"
yum -y install tftp-server
echo "Install ftp"
yum -y install ftp
echo "umount /dvd"
umount /dvd
echo "==============finsihed install package============="

####################copy exports, tftp, and dhcpd##########################
echo "5=>copy File "
echo "copy exports to /etc/export"
cp /PXE_FILE/exports /etc/
echo "copy tftp to /etc/xinetd/tftp"
cp /PXE_FILE/tftp /etc/xinetd.d/
echo "copy dhcp to /etc/dhcpd"
cp /PXE_FILE/dhcpd.conf /etc/dhcp/
echo "=============Finsihed copy file=========="

#############################Make ISO Image################################
echo "6=>Make OS Image "
echo "A) Create ISO Image=>mount dvd[please insert OS into cdrom] "
mount /dev/cdrom /dvd
echo -n "Please enter iso name and path EX: /Centos.iso :"
read isoname
mkisofs -r -o $isoname /dvd
echo "Make OS_Image folder and copy iso into OS iMage folder"
mkdir /OS-Images
mv $isoname /OS-Images

#########copy kernel###################
echo "B) Copy OS Kernel into /install/tftpnoot/kernel "
echo -n "Please enter OS kernl name folder ex: RHEL7.1: "
read kernel_folder
mkdir -p /install/tftpboot/kernel/$kernel_folder
cp /dvd/isolinux/initrd.img /dvd/isolinux/vmlinuz /install/tftpboot/kernel/$kernel_folder

##############setup fstab################
echo "C) automatic mount images to fstab "
echo -n "Please enter iso path EX: /OS-Images/CentOS7.iso: "
read isopath_fstab
echo -n "Make NFS install directory EX: /install/nfs_share/XXX->(Enter XXX): "
read NFS_OS_FOL
mkdir -p /install/nfs_share/$NFS_OS_FOL
echo -n "Please enter save OS location path EX: /install/nfs_share/CentOS7X64:"
read OSpath_fstab 
echo $isopath_fstab" "$OSpath_fstab" ""iso9660 defaults,loop 0 0">> /etc/fstab
echo "mount "
mount -a
echo "=============Finsihed OS Image=========="
###################start servic enad enable service##################
echo "7=>Services Start and enable disable "
echo "A)Enable Serivce:"
echo "A1)vsftpd enable"
systemctl enable vsftpd
echo "A2)dhcpd enable"
systemctl enable dhcpd  
echo "A3)nfs-server enable"
systemctl enable nfs-server  
echo "A4)xinetd enable"
systemctl enable xinetd
echo "A5)tftp enable"
systemctl enable tftp

echo "B)Serivce Restart:"
echo "B1)nfs restart"
service nfs-server restart
echo "A2)nfs-server Restart"
service nfs-server restart
echo "A3)dhcpd Restart"
service dhcpd restart
echo "A4)xinetd Restart"
service xinetd restart
echo "A5)tftp Restart"
service tftp restart
echo "A5)vsftpd Restart"
service vsftpd restart
echo "=============Finsihed Service /Emnable=========="
echo "8=>Firewall setting "
echo "disable firewalld"
systemctl disable firewalld
echo "disable selinux"
systemctl disable selinux
sed -i '7c SELINUX=disabled' /etc/selinux/config
echo "Please reboot your server"

}

###################PXE OS Menu #################################
#function PXE_Menu_single_mode(){}

###################Create fstab PAth #################################
function fstab_single_mode (){
echo -n "Please enter iso path EX: /OS-Images/CentOS7.iso: "
read isopath_fstab 
echo -n "Make NFS install directory EX: /install/nfs_share/XXX->(Enter XXX): "
read NFS_OS_FOL
mkdir -p /install/nfs_share/$NFS_OS_FOL
echo -n "Please enter save OS location path EX: /install/nfs_share/CentOS7X64: "
read OSpath_fstab 
echo $isopath_fstab" "$OSpath_fstab" ""iso9660 defaults,loop 0 0">> /etc/fstab
echo "Umount -a"
umount -a
echo "Start mount -a"
mount -a
}

#########################Convert OS  into ISO##################
function iso_single_mode (){
clear
echo "Convert OS IMAGE into ISO. Please insert cdrom  "
echo "==========================="
echo "1)Used CDROM to mount image "
echo "2)Used directory path "
echo "==========================="
echo -n "option:"
read iso_single_mode_option
if [ "$iso_single_mode_option" == "1" ]; then
echo "Please insert OS into cdrom"
mount /dev/cdrom /dvd
echo -n "Please enter iso name and path EX: /Centos.iso :"
read isoname_iso_single_mode_option
mkisofs -r -o $isoname_iso_single_mode_option /dvd
echo "Make OS_Image folder and copy iso into OS iMage folder"
mv $isoname_iso_single_mode_option /OS-Images

elif [ "$iso_single_mode_option" == "2" ]; then
echo -n "Please type in OS Image Path /dvd/ or /desktop/centos7xx: "
read iso_single_mode_image_path
echo -n "Please enter iso name and path EX: /Centos.iso :"
read isoname_iso_single_mode_option_1
mkisofs -r -o $isoname_iso_single_mode_option_1 $iso_single_mode_image_path
mv $isoname_iso_single_mode_option_1 /OS-Images
else
echo "exit"
fi
}

function image_kernel_single_mode(){
echo "Copy OS Kernel into /install/tftpnoot/kernel "
echo -n "Please enter OS kernl name folder ex: RHEL7.1: "
read kernel_folder_sing
mkdir -p /install/tftpboot/kernel/$kernel_folder_sing
echo -n "Please enter OS iso path EX:/OS-Images/RHEL.iso: "
read isopath_single
if [ ! -d /dvd ]; then
  # if dvd not exist create it
mkdir ./dvd
fi
umount /dvd
echo "mount cdrom"
mount $isopath_single /dvd
cp /dvd/isolinux/initrd.img /dvd/isolinux/vmlinuz /install/tftpboot/kernel/$kernel_folder_sing
echo "Umount /dvd directory"
umount /dvd
}


function PXE_Configure_File(){
echo "================================"
echo "1)Add PXE Menu [not finsihed]"
echo "2)ADD fstab "
echo "3.Make iso file"
echo "4.Make image/kernel file"
echo "q:quit"
echo "================================"
echo -n "Please select option: "
read single_option
if [ "$single_option" == "1" ]; then
PXE_Menu_single_mode
elif [ "$single_option" == "2" ]; then
fstab_single_mode
elif [ "$single_option" == "3" ]; then
iso_single_mode
elif [ "$single_option" == "4" ]; then
image_kernel_single_mode
else
echo "exit"
fi
}
clear
echo "================================"
echo "1)PXE-SETUP "
echo "2)After SETUP "
echo "3.q"
echo "================================"
echo -n "Please select option: "
read STATUS
clear

if [ "$STATUS" == "1" ]; then
PXE_SETUP
elif [ "$STATUS" == "2" ]; then
PXE_Configure_File
else
echo "exit"
fi




