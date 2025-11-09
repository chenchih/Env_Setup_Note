# VNCServer Setup

If you like to use a remote GUI rather than cli command like `ssh`, then VNCServer is a better option. You just have to set up a VNC server on your Ubuntu Server, and you can install VNC viewer on a Windows PC. It will allow you to remotely to your Ubuntu Server. 

VNCViewer I like to use [realvnc](https://www.realvnc.com/en/), where there are many related VNCViewer tools you can download or install

- Update Note status
	- [X] [x11vnc](#x11vnc): Ubuntu Desktop
	- [X] [tigervnc](#tigervnc): Ubuntu Server


## x11vnc

### Installation lightdm and x11vnc
- Step1: install lightdm
```
sudo apt update
sudo apt install lightdm -y #choose lightdm
sudo reboot
```

- Step2: Install x11vnc
```
sudo apt install x11vnc -y
```
- Step3: configure x11vnc services

### Setting configure 

> `sudo nano /lib/systemd/system/x11vnc.service`

Copy and paste these commands, `password` change to your own password in this case it uses password as `password`
```
[Unit]
Description=x11vnc service
After=display-manager.service network.target syslog.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -forever -display :0 -auth guess -passwd password
ExecStop=/usr/bin/killall x11vnc
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

- Step4: Enable x11vnc services
```
#restart services
systemctl daemon-reload

#enable and start x11vnc services
systemctl enable x11vnc.service
systemctl start x11vnc.service

#check if services are enabled
systemctl status x11vnc.service 
```

Check the services is running, and you can see the port, which you will use this port to remote access

![check vnc services status ](img/vncservices.png)

- Step5: disable ScreenLock

Access to `Setting>Privacy>ScreenLock` and disable it

![disable screenlock](img/screenlock_disable.png)

- Step6: VNCViewer to access the Server

Since in Step4 my port is `5900` so I will access `192.168.1.104:5900`

![vnc connection](img/vncviewer_connect.png)

## tigervnc 
This setup is use under **Ubuntu Server**, if you use Desktop then it will not work. It will setup success, howerver whn you use vncviewer the screen is black so this is not use for Desktop version. 

### Installation Xfce and TightVNC
- Install the Xfce and  Desktop
VNC requires a desktop environment using Xfce is a lightweight desktop tool for Linux

If not install, your screen might be a black screen even if you remotely succeed

```
sudo apt-get update
sudo apt-get install xfce4 lightdm-gtk-greeter dbus-x11 autocutsel
```

- Install TightVNC Server
```
sudo apt-get install tightvncserver
```
### Run Vncserver
-  Start VNC Server services 
We need to start initial VNC server, which will ask for your password, and show your VNC server port. The port is important, it tells VNCViewer to connect with which port. 

Note:Please DO NOT run this as the root user. 
```
vncserver
```

- Stop vnc server
```
vncserver -kill :1
```

-  Edit the xstartup Script

You have to modify the file `.vnc/xstartup`, but `.vnc` is a hidden file, so you might not see it. You have to use command line to edit this file name and copy information below in it

```
unset SESSION_MANAGER
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
autocutsel -fork
startxfce4 &
```

- run vncserver with port :1
```
vncserver :1 -geometry 1280x720
```

![vnc start ](img/vncstart.png)

- connect vncserver

If you are Windows you might need a VNC viewer tool such as vncviewer or utravnc, something like it.
> Remote by: `<IP address>:1 `, which port is optional

![vnc connection ](img/vncServer_screebshot.png)

### Enable multiple users use this command:


- Add new user to test multiply user: `adduser test2`
- Login into test2: `sudo -l test2`
- Set vncpassword: `vncserver`
- kill server: `vncserver - kill :2` and add the same configure as above on `.vnc/startup` file
```
unset SESSION_MANAGER
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
autocutsel -fork
startxfce4 &
```

- start vncserver with :2
You can use these two method: 

**Method1**: Allow shared access to the same desktop using the same user.
```
# Method1
vncserver :1 -geometry 1280x720 -alwaysshared
```

**Method2**: Let each user have their own separate desktop with a different user account.

```
#Method2
vncserver :2 -geometry 1280x720
```

### Check your tigervnc process

```
ps aux |grep tightvnc
```
![vnc check process ](img/xtightvnc_process.png)

### Firewall setting

- `vncserver :1`: listens on 5901
- `vncserver :2`: listens on 5902
- `vncserver :3`: listens on 5903

![vnc firewall setting ](img/firewallRule.png)

Enable Firewall will let vnc to block:
```
#firewall is activate
sudo ufw enable
```
You will not be able to access desktop, you have to open port 5901 to be acces to open it. 


so overall if you enable `ufw` firewall then you need to add rule to not block vnc port 

```
#only allow 5901 open
sudo fwd allow 5901/tcp 
```


### Automatically run VNCServer on startup

You have to go in this directory `cd /etc/systemd/system`

> Create VNC services witha  single Desktop
>> `sudo vim vncserver@1.service` , this is single vnc desktop1, if you have multiply please add more file 

```
[Unit]
Description=Start VNC Server With Desktop ID :%i 
After=multi-user.target network.target

[Service]
Type=forking

# Replace your_username with the linux user that connects to this desktop
User=your_username
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
ExecStart=/usr/bin/vncserver :%i -geometry 1280x720 -alwaysshared
ExecStop=/usr/bin/vncserver -kill :%i

[Install]
WantedBy=multi-user.target
```
- Start tigervnc server`
```
#reload
sudo systemctl daemon-reload

#start services
sudo systemctl enable vncserver@1.service

#stop or restart
sudo systemctl stop vncserver@1.service
sudo systemctl restart vncserver@1.service

```

- Change vnc password 
```
vncpasswd
```
More details, please refer [configserverfirewall](https://www.configserverfirewall.com/ubuntu-linux/vnc-ubuntu-server-24/)

## Reference: 
- https://www.crazy-logic.co.uk/projects/computing/how-to-install-x11vnc-vnc-server-as-a-service-on-ubuntu-20-04-for-remote-access-or-screen-sharing
- https://www.youtube.com/watch?v=3K1hUwxxYek&t=271s
- https://www.configserverfirewall.com/ubuntu-linux/vnc-ubuntu-server-24/
