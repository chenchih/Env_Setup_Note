# Setup VSFTP

- OS: Ubuntu 24.04
- inital version: 2025.09.09
- Please refer my config file


## Setup Vsftp Setting

### 1. Install vsftpd

```
sudo apt update
sudo apt install vsftpd -y
```

### 2. Configure vsftpd Settings 

```
sudo cp  /etc/vsftpd.conf  /etc/vsftpd.conf.bk
sudo nano /etc/vsftpd.conf
````


- Anonymous  account 

Default ftp is anonymous account. If you don't want to enter password please use this 

```
anonymous_enable=YES
write_enable=YES
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_root=/var/ftp/
```

- Enable local user access

If you want to secure your accout or use you local username then use this setup

```
local_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
```

### 3. Set Up Directory Permissions

```
# Ensure the root FTP directory is owned by root
sudo chown root:root /var/ftp
sudo chmod 755 /var/ftp

# Create the upload directory
sudo mkdir -p /var/ftp/pub

# Assign ownership of the upload directory to the ftp user
sudo chown ftp:ftp /var/ftp/pub
sudo chmod 755 /var/ftp/pub
```

### 4. Restart the Service

```
sudo systemctl restart vsftpd
```

Firewall setting (optional)
```
sudo ufw allow 20/tcp
sudo ufw allow 21/tcp
```

### 5. Check Services 

```
sudo systemctl status vsftpd
```



### 6. Connect your Client to server 

Ftp client as window example:

```
ftp <IP address> 
cd pub 
```

You have to navigate to pub directory in order to upload or download file.

- `put`: upload
- `get`: download



