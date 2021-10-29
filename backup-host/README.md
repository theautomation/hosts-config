# Ubuntu Server as backup server

### After clean installation of Ubuntu Server:

## Upgrade

1. Package update

```bash
sudo apt-get update
```

2. System upgrade

```bash
sudo apt-get upgrade -y
```

## Setup SSH

1. Add file `/etc/default/ufw`

2. Add file `/etc/ssh/sshd_config.d/custom.conf`

3. Allow port 2244

```bash
sudo ufw allow 2244/tcp
```

4. allow outgoing connect from server

```bash
sudo ufw default allow outgoing
```

5. Block all incoming connection except ssh by default

```bash
sudo ufw default deny incoming
```

6. Turn on and enable ufw

```bash
sudo ufw enable
```

7. Change defualt port for SSH add file `/etc/ssh/sshd_config.d/custom.conf`
8. Edit hosts.allow `/etc/hosts.allow`
9. Edit hosts.deny `/etc/hosts.deny`
10. Create SSH key

```bash
mkdir /home/coen/.ssh
```

```bash
cd /home/coen/.ssh
```

```bash
ssh-keygen -t rsa -b 4096
```

11. Copy pub key to remote machine

```bash
ssh-copy-id -p 2244 coen@<remote ip address>
```

12. Deny login with password, uncomment "`#PasswordAuthentication no`" in `/etc/ssh/sshd_config.d/custom.conf`

13. Create config file on the host machine `/home/coen/.ssh/config`

```
Host backup-host
    HostName <remote ipaddress>
    User coen
    Port 2244
```

## Setup ZFS

1. Install zfs

```bash
sudo apt install zfsutils-linux -y
```

2. check if ZFS was installed correctly

```bash
whereis zfs
```

3. Check installed drives

```bash
sudo fdisk -l
```

4. To create a mirrored pool, backup-pool is the name of the pool

```bash
sudo zpool create backup-pool mirror /dev/sdb /dev/sdc -f
```

5. Show zpool status

```bash
sudo zpool status
```

example output:

```console
coen@backup-host:~$ sudo zpool status
  pool: backup-pool
 state: ONLINE
  scan: none requested
config:

        NAME         STATE     READ WRITE CKSUM
        backup-pool  ONLINE       0     0     0
          mirror-0   ONLINE       0     0     0
            sdb      ONLINE       0     0     0
            sdc      ONLINE       0     0     0

errors: No known data errors
```

6. The newly created pool is mounted at `/backup-pool/`

7. change the owner of the mountpoint recursively

```bash
sudo chown -R $USER:$USER /backup-pool
```
