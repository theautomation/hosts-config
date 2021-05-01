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
Kerberos Realm: STAM.LAN\
Kerberos servers for your realm: dc1.stam.lan\
Administrative server for your Kerberos realm: dc1.stam.lan

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

Realm [STAM.LAN]:\
Domain [STAM]:\
Server Role (dc, member, standalone) [dc]:\
DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) [SAMBA_INTERNAL]:\
DNS forwarder IP address (write 'none' to disable forwarding) [127.0.0.53]:  192.168.1.3\
Administrator password:\
Retype password:

#### Copy the Kerberos config file
```bash
#!/bin/bash 
sudo cp /var/lib/samba/private/krb5.conf /etc/
``` 

#### Stop and disable the samba services and the dns resolver service
```bash
#!/bin/bash 
sudo systemctl disable --now smbd nmbd winbind systemd-resolved
``` 

#### Unmask the SAMBA AD service
```bash
#!/bin/bash 
sudo systemctl unmask samba-ad-dc
``` 

#### Enable and start the AD service
```bash
#!/bin/bash 
sudo systemctl enable --now samba-ad-dc
``` 

#### Show the functtional levels of the AD
```bash
#!/bin/bash 
sudo samba-tool domain level show
``` 

#### Recreate the dns nameserver file
```bash
#!/bin/bash 
sudo rm -f /etc/resolv.conf && sudo nano /etc/resolv.conf
``` 

### Active Directory is now ready! Try joining a Windows 10 PC to the AD domain.

#### This is how you create a user
```bash
#!/bin/bash 
sudo samba-tool user create pietje
``` 
