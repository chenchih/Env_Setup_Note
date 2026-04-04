# Remote Tool Setting


## Setup xrdp
xrdp is a GUI remote tool allow window user to remote to Ubuntu GUI, which is quite usefull. 
Ubuntu Version: 

### Default Ubuntu Desktop (GNOME) 

1. Update Your System

```
sudo apt update
sudo apt upgrade -y
```

2. Install xrdp and Enable and Start XRDP 
```
sudo apt install xrdp -y
sudo systemctl enable --now xrdp
#sudo systemctl enable xrdp
sudo systemctl restart xrdp
sudo systemctl status xrdp
```

3. Add ssl-cert group 

```
sudo adduser xrdp ssl-cert
sudo systemctl restart xrdp
```

4. Firewall Setting 
```
sudo ufw enable
sudo ufw allow 3389/tcp
sudo ufw reload
sudo ufw status
```

5. Chek your IP address

Show IP address info (brief format)

```
sudo ip -br a
```

6. Fix Black screen issue 

```
sudo vim /etc/xrdp/startwm.sh
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR
sudo systemctl restart xrdp
```

Connect to Your Ubuntu Machine on Window Side

You can use shortcut `window+r` and type `MSTSC`, it will launch Remote App tool. 

### XFCE 
If you perfer using XFCE you can use below method, just add below command

- Install a Desktop Environment
```
sudo apt install xfce4 xfce4-goodies –y
```

- Configure XRDP to Use Xfce

```
echo xfce4-session > ~/.xsession
sudo systemctl restart xrdp
```

- edit startwm.sh (option)
```
sudo nano /etc/xrdp/startwm.sh
```

add below content 

```
[ORG]
exec startxfce4
```

### Reference
- https://medium.com/@piyushkashyap045/how-to-install-xrdp-on-an-ubuntu-machine-a-simple-guide-1e229214aa36