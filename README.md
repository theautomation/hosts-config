# Proxmox Virtual Environment

## PVE maintenance

### Change update repositories
#### Disable Commercial Repo
```bash
sed -i "s/^deb/\#deb/" /etc/apt/sources.list.d/pve-enterprise.list
apt-get update
``` 
#### Add PVE Community Repo
```bash
echo "deb http://download.proxmox.com/debian/pve $(grep "VERSION=" /etc/os-release | sed -n 's/.*(\(.*\)).*/\1/p') pve-no-subscription" > /etc/apt/sources.list.d/pve-no-enterprise.list
apt-get update
``` 
#### Remove nag (licence popup)
```bash
echo "DPkg::Post-Invoke { \"dpkg -V proxmox-widget-toolkit | grep -q '/proxmoxlib\.js$'; if [ \$? -eq 1 ]; then { echo 'Removing subscription nag from UI...'; sed -i '/data.status/{s/\!//;s/Active/NoMoreNagging/}' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js; }; fi\"; };" > /etc/apt/apt.conf.d/no-nag-script
apt --reinstall install proxmox-widget-toolkit
``` 


### Delete or create partition(s)
#### Start fdisk on sda
```bash
fdisk /dev/sda
``` 

#### Load the current partition table to check the number of the partition that needs to be deleted
```bash
After "Command (m for help):", enter: p
``` 

#### To delete
```bash
After "Command (m for help):", enter: d
``` 
```bash
After "Partition number 1,9, default 9):", enter the partition number: 9
``` 
#### To save the changes:
```bash
After "Command (m for help):" enter: w
``` 

### Destroy a ZFS pool
```bash
zpool destroy <poolname>
``` 
