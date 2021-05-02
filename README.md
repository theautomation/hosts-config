# Proxmox Virtual Environment

## PVE maintenance

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

