# Setup GenieACS (opensource)

This is a tutorial of how to setup genieacs server under ubuntu. Below are the step you can setup manually, but i also provide automation bash script, which will allow to automatic install and setup. The script support both libssl1.1 and libssl3.3. 
- script name: `genie_acs_new.sh`
- how to run: `./genie_acs_new.sh`

![flow of automation](img/genie_automatic.png)

**Note:**  `Ubuntu 20.04` and `24.04` setup are different I spend reinstall these OS and figure out. There are many resource teach you Ubuntu 20.04, however I will also write how to setup under 20.04 in case you want to see the comparison. 
- Ubuntu 20.04: SSL uses 1.1.1 and monodb use 4.4
- Ubuntu 22.04 or 24.04: SSL uses 3.X and mogodb use 8.0]

## Content

- [Ubuntu 20.04](#ubuntu24)
- [Ubuntu 22.04 or 24.04:](#ubuntu20)
- [Run GenieACS](#RunGenieACS)


##  <a id="systemcheck"> Raspeberry PI5 setting check OS </a>
Let me show some of the OS information and PI5 setting

- check OS version
```
lsb_release -a
```
![check os](img/checkOS.PNG)


- check kernel 
you can use either of this command: 
> `uname -ar` or
> `hostnamectl`

- check cpu type
This is important if you want to install specfic package you need to know it's arm cpu 
```
lscpu
```
![check cpu](img/CPUType.PNG)

- check Raspeberry Model and type
you can use either one to check model:

> `cat /proc/device-tree/model`
> `cat /proc/cpuinfo | grep 'Model'`

![check model](img/modelType.PNG)

## <a id="ubuntu24"> Ubuntu 24.04 Setup </a>

Check your OS version using these command: 
```
lsb_release -a
cat /etc/*release
```
### Step1: Install node.js

```
curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install nodejs
node -v
```
### Step2: Install MongoDB
Skip install SSL, default ubuntu 20.04 already install and use libssl3, you can check by this command `dpkg -l | grep libssl3`

#### 2.1 MogoDB GPG Key
```
#update
sudo apt update 
#install curl
sudo apt install gnupg curl -y 
#use curl to download mogodb
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \ sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \ --dearmor
```
#### 2.2 Mogo installation
```
#add the url into sources.list
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
#update 
sudo apt update

# Install MongoDB
sudo apt install -y mongodb-org

# Start and Enable the MongoDB Service
sudo systemctl start mongod 
sudo systemctl enable mongod 
sudo systemctl status mongod
```

### Step3: Install GenieACS
```
sudo apt update
sudo apt install nodejs npm

sudo npm install -g genieacs@1.2.13
sudo useradd --system --no-create-home --user-group genieacs

mkdir /opt/genieacs
mkdir /opt/genieacs/ext
chown genieacs:genieacs /opt/genieacs/ext

```

### Step4: Configure GenieACS
You cab refer this [GenieACS](#http://docs.genieacs.com/en/latest/installation-guide.html#install-genieacs)

#### edit genieacs.env
> `vi /opt/genieacs/genieacs.env` 
```
GENIEACS_CWMP_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-cwmp-access.log
GENIEACS_NBI_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-nbi-access.log
GENIEACS_FS_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-fs-access.log
GENIEACS_UI_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-ui-access.log
GENIEACS_DEBUG_FILE=/var/log/genieacs/genieacs-debug.yaml
NODE_OPTIONS=--enable-source-maps
GENIEACS_EXT_DIR=/opt/genieacs/ext
```

- Set file ownership and permissions:
```
sudo chown genieacs:genieacs /opt/genieacs/genieacs.env
sudo chmod 600 /opt/genieacs/genieacs.env
```

#### add jwt secret
Add jwt secret if not it will occur error like below picture: 
```
node -e "console.log(\"GENIEACS_UI_JWT_SECRET=\" + require('crypto').randomBytes(128).toString('hex'))" >> /opt/genieacs/genieacs.env
```
![activate_genieacs](img/secretkey.PNG)

#### Create logs directory
```
mkdir /var/log/genieacs
chown genieacs:genieacs /var/log/genieacs
```
#### Create genieacs-cwmp systemd unit files

Note: if you want to check the full path use `which genieacs-cwmp`

> `sudo systemctl edit --force --full genieacs-cwmp`
```
[Unit]
Description=GenieACS CWMP
After=network.target

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/bin/genieacs-cwmp

[Install]
WantedBy=default.target
```

#### Create genieacs-nbi systemd unit files

Note: if you want to check the full path use `which genieacs-nbi`

> `sudo systemctl edit --force --full genieacs-cwmp`
```
[Unit]
Description=GenieACS NBI
After=network.target

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/local/bin/genieacs-nbi

[Install]
WantedBy=default.target
```

#### Create genieacs-fs systemd unit files

Note: if you want to check the full path use `which genieacs-fs`

```
[Unit]
Description=GenieACS FS
After=network.target

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart =/usr/local/bin/genieacs-fs

[Install]
WantedBy=default.target

```
#### Create genieacs-ui systemd unit files

Note: if you want to check the full path use `which genieacs-ui`

> `sudo systemctl edit --force --full genieacs-ui`
```
[Unit]
Description=GenieACS UI
After=network.target

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/local/bin/genieacs-ui 

[Install]
WantedBy=default.target
```

#### Create logroate
> `nano /etc/logrotate.d/genieacs`

```
/var/log/genieacs/*.log /var/log/genieacs/*.yaml {
    daily
    rotate 30
    compress
    delaycompress
    dateext
}

```

### Enable and start services 
```
sudo systemctl enable genieacs-cwmp
sudo systemctl start genieacs-cwmp
sudo systemctl status genieacs-cwmp

sudo systemctl enable genieacs-nbi
sudo systemctl start genieacs-nbi
sudo systemctl status genieacs-nbi

sudo systemctl enable genieacs-fs
sudo systemctl start genieacs-fs
sudo systemctl status genieacs-fs

sudo systemctl enable genieacs-ui
sudo systemctl start genieacs-ui
sudo systemctl status genieacs-ui
```

It should be able to access Genie ACS if nothing is wrong, navigate web: http://<IP>:3000
YOu can use `ip a` or `hostname -I` to check your IP address

## <a id="ubuntu20"> Ubuntu 20.04 Setup</a>
please run this command to allow running multiply process, in case execute command run `waiting for cache lock` this issue:
```
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/lib/dpkg/lock
sudo rm /var/cache/apt/archives/lock
sudo dpkg --configure -a
sudo apt update

```
### Step1: Install node.js
```
curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install nodejs
node -v
```
### Step2: Install MongoDB

- 1 download libssl
```
echo "deb http://security.ubuntu.com/ubuntu impish-security main" | sudo tee /etc/apt/sources.list.d/impish-security.list
sudo apt-get update
```
- install mogodb
```
sudo apt update
sudo apt install mongodb-org
sudo systemctl start mongod.service
sudo systemctl status mongod
sudo systemctl enable mongod
mongo --eval 'db.runCommand({ connectionStatus: 1 })'

```

### Step3: Install GenieACS

Same as 24.04
```
sudo apt update
sudo apt install nodejs npm

sudo npm install -g genieacs@1.2.13
sudo useradd --system --no-create-home --user-group genieacs

mkdir /opt/genieacs
mkdir /opt/genieacs/ext
chown genieacs:genieacs /opt/genieacs/ext

```

### Step4: Configure GenieACS
You cab refer this [GenieACS](#http://docs.genieacs.com/en/latest/installation-guide.html#install-genieacs)

#### edit genieacs.env
> `vi /opt/genieacs/genieacs.env` 
```
GENIEACS_CWMP_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-cwmp-access.log
GENIEACS_NBI_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-nbi-access.log
GENIEACS_FS_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-fs-access.log
GENIEACS_UI_ACCESS_LOG_FILE=/var/log/genieacs/genieacs-ui-access.log
GENIEACS_DEBUG_FILE=/var/log/genieacs/genieacs-debug.yaml
NODE_OPTIONS=--enable-source-maps
GENIEACS_EXT_DIR=/opt/genieacs/ext
```

- Set file ownership and permissions:
```
sudo chown genieacs:genieacs /opt/genieacs/genieacs.env
sudo chmod 600 /opt/genieacs/genieacs.env
```

#### add  jwt secret
```
node -e "console.log(\"GENIEACS_UI_JWT_SECRET=\" + require('crypto').randomBytes(128).toString('hex'))" >> /opt/genieacs/genieacs.env
```
![activate_genieacs](img/secretkey.PNG)

#### Create logs directory
```
mkdir /var/log/genieacs
chown genieacs:genieacs /var/log/genieacs
```
#### Create genieacs-cwmp systemd unit files

Note: if you want to check the full path use `which genieacs-cwmp`

> `sudo systemctl edit --force --full genieacs-cwmp`
```
[Unit]
Description=GenieACS CWMP
After=network.target

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/bin/genieacs-cwmp

[Install]
WantedBy=default.target
```

#### Create genieacs-nbi systemd unit files

Note: if you want to check the full path use `which genieacs-nbi`

> `sudo systemctl edit --force --full genieacs-cwmp`
```
[Unit]
Description=GenieACS NBI
After=network.target

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/bin/genieacs-nbi

[Install]
WantedBy=default.target

```

#### Create genieacs-fs systemd unit files

Note: if you want to check the full path use `which genieacs-fs`

```
[Unit]
Description=GenieACS FS
After=network.target

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/bin/genieacs-fs

[Install]
WantedBy=default.target

```
#### Create genieacs-ui systemd unit files

Note: if you want to check the full path use `which genieacs-ui`

> `sudo systemctl edit --force --full genieacs-ui`
```
[Unit]
Description=GenieACS UI
After=network.target

[Service]
User=genieacs
EnvironmentFile=/opt/genieacs/genieacs.env
ExecStart=/usr/bin/genieacs-ui

[Install]
WantedBy=default.target
```

#### Create logroate
> `nano /etc/logrotate.d/genieacs`

```
/var/log/genieacs/*.log /var/log/genieacs/*.yaml {
    daily
    rotate 30
    compress
    delaycompress
    dateext
}

```

## <a id="RunGenieACS">Run GenieACS</a>

### Enable and start services 
```
sudo systemctl enable genieacs-cwmp
sudo systemctl start genieacs-cwmp
sudo systemctl status genieacs-cwmp

sudo systemctl enable genieacs-nbi
sudo systemctl start genieacs-nbi
sudo systemctl status genieacs-nbi

sudo systemctl enable genieacs-fs
sudo systemctl start genieacs-fs
sudo systemctl status genieacs-fs

sudo systemctl enable genieacs-ui
sudo systemctl start genieacs-ui
sudo systemctl status genieacs-ui
```

It should be able to access Genie ACS if nothing is wrong, navigate web: http://<IP>:3000
YOu can use `ip a` or `hostname -I` to check your IP address

- step1 Navigate your web to `http://<IP>:3000` and click link to activate

![activate_genieacs](img/activate.PNG)

### CPE Set acs URL to do register

Please use the correct command to set acs server, every command might be different 
```
setvalue Device.ManagementServer.URL="http://172.21.201.111:7547"
setvalue Device.ManagementServer.ConnectionRequestUsername="admin"
setvalue Device.ManagementServer.ConnectionRequestPassword="admin"
```
![check_cpeOnline_genieacs](img/acs_online.PNG)

### You can also do fw upgrade
#### setup your file setting
- Step1: Click on devices to check register success 
- Step2: copy the correct OUI, product class
- Step3: click on Admin page and click files
- Step4: Enter the correct information OUI, product class, and version
![check_cpeOnline_genieacs](img/upgrade_image.PNG)

- Step5: please select your image and uplaod it
![check_cpeOnline_genieacs](img/img_list.PNG)

#### CPE Upgrade
Continue from above you have to add image first. 

- click on device your want to upgrade
- select the devices you want to upgrade 
- click push file 
- select the image you want to upgrade
- click queue and commit 

You can refer below pciture: 
![upgrade_cpe](img/upload_fw.PNG)
