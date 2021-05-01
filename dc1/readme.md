## Installation
### Basics
#### Assign a static IP to the server. Ubuntu Server uses netplan for network management
```bash
#!/bin/bash
sudo nano /etc/netplan/00-installer-config.yaml
```
#### Copy paste this in the 00-installer-config.yaml file
```bash
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
      - 192.168.1.4/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [192.168.1.3]
        search: []
``` 
#### Set correct timezone on host
```bash
#!/bin/bash 
sudo timedatectl set-timezone Europe/Amsterdam
``` 
#### Update and upgrade
```bash
#!/bin/bash 
sudo apt update -y
sudo apt upgrade -y
``` 
#### Change the hostname and update the hosts file
```bash
#!/bin/bash 
sudo nano /etc/hostname
``` 
dc1.stam.lan
```bash
#!/bin/bash 
sudo nano /etc/hosts
``` 
192.168.1.4 dc1.stam.lan dc1

```bash
#!/bin/bash 
sudo reboot
``` 
### Samba Active Directory
#### Install the SAMBA 4 Active Directory packages
```bash
#!/bin/bash 
sudo apt -y install samba krb5-config winbind smbclient
``` 
#### Backup the original SAMBA config file
```bash
#!/bin/bash 
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.original
``` 
#### Provision the domain controller
```bash
#!/bin/bash 
sudo samba-tool domain provision
``` 
