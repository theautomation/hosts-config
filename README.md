# Proxmox Virtual Environment installed on bare metal.

## PVE maintenance

#### To start fdisk on sda:
'''
fdisk /dev/sda
'''
To load the current partition table to check the number of the partition that needs to be deleted:
After "Command (m for help):", enter: p
To delete /dev/sda5:
After "Command (m for help):", enter: d
After "Partition number 1,2, 5-7, default 7):", enter the partition number: 5
You'll see: "Partition 5 has been deleted"
To reload the partition table and check the intended change was made:
After "Command (m for help):", enter: p
To save the changes:
After "Command (m for help):" enter: w
