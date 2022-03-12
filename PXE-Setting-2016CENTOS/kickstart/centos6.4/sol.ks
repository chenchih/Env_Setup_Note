# Kickstart file automatically generated by anaconda.

#version=DEVEL
install
#nfs --server=192.168.2.1 --dir=/install/nfs_share/centos6.4
url --url="http://192.168.2.1/Centos6.4"
lang en_US.UTF-8
keyboard us
network --onboot yes --device eth0 --bootproto dhcp --noipv6
#network --onboot yes --device eth1 --bootproto dhcp --noipv6
rootpw  --iscrypted $6$xY2tioS3mrtkbBsv$HQGUhCW.jjnMwTOFz1XM/1OjsrP3BdE4sJZUDd1Zr.iNhqkjQJj4.gkn70aMwYsouY4mpbBrW.DRBeXQ9krap0
#firewall --service=ssh
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
timezone --utc America/Danmarkshavn
bootloader --location=partition --driveorder=sda --append="crashkernel=auto console=ttyS1,57600"
# The following is the partition information you requested
# Note that any partitions you deleted are not expressed
# here so unless you clear all partitions first, this is
# not guaranteed to work
#clearpart --all --drives=sda
#volgroup VolGroup --pesize=4096 pv.008003
#logvol /home --fstype=ext4 --name=lv_home --vgname=VolGroup --grow --size=100
#logvol / --fstype=ext4 --name=lv_root --vgname=VolGroup --grow --size=1024 --maxsize=51200
#logvol swap --name=lv_swap --vgname=VolGroup --grow --size=4096 --maxsize=4096

#part /boot/efi --fstype=efi --grow --maxsize=200 --size=50
#part /boot --fstype=ext4 --size=500
#part pv.008003 --grow --size=1
#unsupported_hardware
clearpart --all
#repo --name="CentOS"  --baseurl=nfs:192.168.2.1:/install/nfs_share/centos6.4 --cost=100
autopart

%post
#!/bin/bash
#wget -r -nH ftp://192.168.2.1/V14_20141106.tar.gz
#tar -zxvf /V12_20141106.tar.gz
wget -r -nH ftp://192.168.2.1/PXE_server.tar.gz
tar -zxvf /PXE_server.tar.gz
wget -r -nH ftp://192.168.2.1/V14_20150203.tar.gz
tar -zxvf /V14_20150203.tar.gz
wget -r -nH ftp://192.168.2.1/centos6.4.iso
%packages
@core
@network-file-system-client
@development
@server-policy
@system-management
freeipmi-ipmidetectd
ipmitool
freeipmi
freeipmi-bmc-watchdog
watchdog
fence-agents
openhpi-subagent
OpenIPMI
openhpi
ftp
lftp
tftp
telnet-server
telnet
wget
%end
