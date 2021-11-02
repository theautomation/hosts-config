#!/bin/bash
#
# this script will backup files and folders from local machine to a remote machine over ssh.
# script writtin by Coen Stam.
# github@theautomation.nl
#

set -e

# ----------------------------------------------------------------------------------- 
# select if ssh configuation from /.ssh/config must be used or not. 
# see also https://github.com/theautomation/hosts-config/tree/main/backup-host#setup-ssh
# 1 = use the user, host and port from a ssh config file stored in /.ssh/config.
# 0 = use ssh variables user, host and port from the variables below in this script.
ssh_config="1"

# if ssh_config => 1 
# remote hostname from .ssh/config.
remote_host_from_config="backup-host"

# if ssh_config => 0
# user of the remote host.
remote_user="coen"
# ip address of the remote host.
remote_host="192.168.1.234"
# remote ssh port.
remote_port=2244

# rsync options in command (optional).
# more options can be found at https://linux.die.net/man/1/rsync
rsync_options="--archive --partial --stats --verbose --delete"

# absolute path of the exclude list location for rsync as external file.
rsync_excludelist="/home/coen/hosts-config/proxmox-ve/docker-host/backup_exclude"

# rsync source path being copied
rsync_sourcepath="/mnt/slow-storage/coen
                  /mnt/slow-storage/anne"

# destination path for rsync
rsync_destinationpath="/backup-pool/coen/rsync"
# -----------------------------------------------------------------------------------

echo "Starting backup of ${rsync_sourcepath}."


if [ "${ssh_config}" = "1" ]; then
  if [ ! -f ${HOME}/.ssh/config ]; then
    echo "script stopped, ssh_config is set to 1 but there is no .ssh config file found in ${HOME}/.ssh/, create ssh config file or set ssh_config => 0 to use <user>, <host>, <port> from the variables in this script."
    exit 2
  elif [ -z "${remote_host_from_config}" ]; then
    echo "script stopped, ssh_config is set to 1 but backup_host variable is empty."
    exit 3
  else
  
  echo "starting rsync using ssh config file"
  rsync ${rsync_options} --exclude-from="${rsync_excludelist}" ${rsync_sourcepath} ${remote_host_from_config}:${rsync_destinationpath}
  fi
    echo "start rsync with <user>, <host>, <port> from .ssh/config..."
elif [ "${ssh_config}" = "0" ]; then
  if [ -z "${remote_user}" ] || [ -z "${remote_host}" ] || [ -z "${remote_port}" ]; then
  echo "script stopped, ssh_config is set to 0 but one or more variables for are undefined, check remote user, host and port variable(s)"
  exit 4
  else
  echo "start rsync with ${remote_user}, ${remote_host}, ${remote_port} from script variable..."
  rsync ${rsync_options} --exclude-from="${rsync_excludelist}" --delete-excluded -e "ssh -p ${remote_port}" ${rsync_sourcepath} ${remote_user}@${remote_host}:${rsync_destinationpath}
  fi
fi

echo "all done..."
exit 0