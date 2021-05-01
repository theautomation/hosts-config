## Installation

### Assign a static IP to the server. Ubuntu Server uses netplan for network management.

```bash
#!/bin/bash
sudo nano /etc/netplan/00-installer-config.yaml
```

### Copy paste this in the 00-installer-config.yaml file.
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
 
 ### Set correct timezone on host.
```bash
#!/bin/bash 
sudo timedatectl set-timezone Europe/Amsterdam
``` 
