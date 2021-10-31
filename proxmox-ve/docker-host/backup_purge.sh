#!/bin/bash
#
# rsync info at https://linux.die.net/man/1/rsync
# tar info at https://linux.die.net/man/1/tar
# this sript will backup files and folders from local host machine to a remote machine over ssh
# script writtin by Coen Stam 
# github@theautomation.nl
#

# exit if an error occurs
set -e

# rsync options
rsync_options="--archive --partial --stats --verbose --remove-sent-files"
# absolute path of the exclude list for rsync as external file.
rsync_excludelist="/home/coen/hosts-config/proxmox-ve/docker-host/backup_exclude"
# absolute path to tarball with tar
tar_sourcepath="/home/coen/docker-home-services/adguard-home"
# absolute destination path for saving tar file
tar_destinationpath="/backup-pool/coen/purge/"
# tar options
tar_options="--create --gzip --verbose"
# tar filename
tar_name="$(date '+%y-%m-%d').tar.gz"
# temporary directory for tar file
tar_tempdir="/mnt/slow-storage/temp"

# user of the remote machine 
remoteuser="coen" #optional
# ip address of the remote machine 
remotehost="192.168.1.234" #optional
# remote ssh port
remoteport="2244" #optional
# uncomment the command below when the above <user>, <host>, <port> is used
rsync_command_1="$(rsync ${rsync_options} --exclude-from="${rsync_excludelist}" --delete-excluded -e 'ssh -p ${remoteport}' ${tar_tempdir}/*.tar* ${remoteuser}@${remotehost}:${tar_destinationpath}"

# remote host from .ssh/config
remotehostfromconfig="backup-host"

echo "Starting backup of ${tar_sourcepath}."

if [ ! -d ${tartempdir} ]; then
  mkdir ${tartempdir}
  echo "created temporary directory for tar file in ${tar_tempdir}."
fi

if [ ! -f ${rsync_excludelist} ]; then
  echo "script stopped, there is no exclude list in $PWD/"
  exit 1
fi

echo "starting tar ..."
tar ${tar_options} --file ${tar_tempdir}/${tar_name} ${tar_sourcepath}

echo "start sending tar with rsync ..."

# using rsync command with host, ip, port from script variable else from .ssh.config file.
if rsync_command_1; then
  echo "start rsync with host, ip, port from script variable ..."
else
  if [ ! -f ${HOME}/.ssh/config ]; then
    echo "script stopped, ther is no .ssh config file in ${HOME}/.ssh/, please set <user>, <host>, <port> in the variables."
    exit 2
  fi
 echo "start rsync with <user>, <host>, <port> from .ssh/config ..."
 rsync ${rsync_options} --exclude-from="${rsync_excludelist}" --delete-excluded ${tar_tempdir}/*.tar* ${remotehostfromconfig}:${tar_destinationpath}
fi

echo "deleting older tar files on remote machine ..."
ssh -p ${remoteport} ${remoteuser}@${remotehost} "find ${tar_destinationpath} -type f -mtime +31 -name *.tar* -delete"
echo "all done..."

exit 0