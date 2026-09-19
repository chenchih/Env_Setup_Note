# AnyDesk Installation Setup

AnyDesk is a remote desktop tool allow to remote like teamviewer. 

You need to Install Ubuntu Desktop version to work with anydesk. 


## 1. Run below step to download anydesk
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

## 2. Download and Install AnyDesk
```
# Update apt caches and install the AnyDesk client
sudo apt update
sudo apt install anydesk
```

## 3. Edit gdp to allow to remote
If you don't set this when remote to this server anydesk will occur `Display_Server_Not_Supported Error`. 

Solution: edit the gdm3 config `sudo nano /etc/gdm3/custom.conf`

```

WaylandEnable=false
AutomaticLoginEnable=true
AutomaticLogin=$USERNAME
```

## 4. Enable and check services 
```
systemctl start anydesk
systemctl status anydesk
```

## 5. Reboot your Server 




## Reference

- https://kafeiou.pw/ubuntu-24-04-%E5%AE%89%E8%A3%9D-anydesk/