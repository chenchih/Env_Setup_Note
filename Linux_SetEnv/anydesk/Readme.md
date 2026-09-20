# AnyDesk Installation Setup

AnyDesk is a remote desktop tool allow to remote like teamviewer. 

You need to Install Ubuntu Desktop version to work with anydesk. 

There is two method to install anydesk, you can either use: 
- Download anydesk from offical site 
- Download with repository 

- System: Ubuntu 22.04

## Install AnyDesk 

### Method 1: download via officalsite

Download anydesk from offical site 

### Method 2: Download and Installation

- Set anydesk GPG key
If you don't add this, will not be able to use apt install AnyDesk

```
# Add the AnyDesk GPG key
sudo apt update
sudo apt install ca-certificates curl apt-transport-https
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY -o /etc/apt/keyrings/keys.anydesk.com.asc
sudo chmod a+r /etc/apt/keyrings/keys.anydesk.com.asc

# Add the AnyDesk apt repository
echo "deb [signed-by=/etc/apt/keyrings/keys.anydesk.com.asc] https://deb.anydesk.com all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list > /dev/null
```

Download and Install AnyDesk
```
# Update apt caches and install the AnyDesk client
sudo apt update
sudo apt install anydesk
```

## 3. Configure GDM config 

If you don't set GDM this when remote it might occur `Display_Server_Not_Supported Error`. 

**Solution**: Edit the `gdm3` config `sudo nano /etc/gdm3/custom.conf`

```
# Uncomment the line below to force the login screen to use Xorg
WaylandEnable=false

# Enabling automatic login
AutomaticLoginEnable=true
AutomaticLogin=$USERNAME
```

You can also logout and click the gear and choose `Ubuntu on Xorg` but in Ubuntu `25.10` this gear is remove

> **Note:** Ubuntu `25.10` drops support for GNOME on Xorg, meaning Wayland is mandatory for the default GNOME desktop environment, and modifying WaylandEnable=false in `/etc/gdm3/custom.conf` no longer forces the system back to an X11 GNOME


### Solution for Ubuntu 25.10 

Ubuntu 25.10 GNOME session has no Xorg option, so we have to use xfce option in order to solve the issue. 

You can check display type if it show `wayland` then disable not work, it . 

```
echo $XDG_SESSION_TYPE
#output: x11 or wayland
```

To solve it please install `xdesktop-desktop`, and change `XSession=ubuntu` to `XSession=xfce` 


```
# install 
sudo apt install xubuntu-desktop
```

Method1: Set via desktop

logout then click username and click on the Gear to chnage default display `Ubuntu` to `xfce session`. 

Method2: Set via Command
```
# modify 
sudo nano /var/lib/AccountsService/users/test
[User] 
XSession=xfce 
```

Edit `/etc/gdm3/custom.conf` and change Login to username, it will automatic login. If you don't automatic login anydesk will ocuur display error, you have to login manually. 
```
# Uncomment the line below to force the login screen to use Xorg
WaylandEnable=false

# Enabling automatic login
AutomaticLoginEnable=true
AutomaticLogin=test
```

Note: you can also use the login page gear to change your dekstop type tp xfce. 

## 4. Reboot your Server 

```
reboot
```


## 5. Configure Anydesk login password.

Set anydesk password to `P@ssw0rd2026` 

```
echo "P@ssw0rd2026" | sudo anydesk --set-password
```

## 6. Enable and check services 
```
systemctl start anydesk
systemctl is-enabled anydesk
systemctl status anydesk
```


## Reference

- https://kafeiou.pw/ubuntu-24-04-%E5%AE%89%E8%A3%9D-anydesk/
- https://www.configmanual.com/blog/how-to-fix-display-server-not-supported-error-in-anydesk-on-linux