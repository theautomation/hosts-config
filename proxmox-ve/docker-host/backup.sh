#!/bin/bash
#
# rsync info at https://linux.die.net/man/1/rsync
# this sript will backup files and folders from local host machine to a remote machine over ssh
# script writtin by Coen Stam 
# github@theautomation.nl
#

# exit if an error occurs
set -e

## rsync variables for synchronization
# rsync source path being copied
rsync_sourcepath="/mnt/slow-storage/coen
                  /mnt/slow-storage/anne"
# destination path for rsync
rsync_destinationpath="/backup-pool/rsync"
# rsync options
rsync_options="--archive --partial --progress --verbose"
# exclude files and/or folders for rsync
rsync_exclude=

## tar variables for purge
# source path tarball with tar
tar_sourcepath="/home/coen/docker-home-services/"
# destination path for tar file
tar_destinationpath="/backup-pool/purge/"
# tar options
tar_options="--create"
# tar filename
tar_name="$(date '+%y-%m-%d').tar"
# temporary directory for tar file
tar_tempdir="/mnt/slow-storage/temp"


# user of the remote machine
remoteuser="coen"
# ip address of the remote machine
remotehost="192.168.1.234"
# remote ssh port
remoteport="2244"

echo "starting backup..."

# upload tar files to remote backup host and purge old ones
if [ ! -d ${tartempdir} ]; then
  mkdir ${tartempdir}
  echo "created temporary directory for tar file in ${tar_tempdir}"
fi

tar ${tar_options} --file ${tar_tempdir}/${tar_name} ${tar_sourcepath}

rsync ${rsync_options} --remove-sent-files -e "ssh -p ${remoteport}" ${tar_tempdir}/*.tar ${remoteuser}@${remotehost}:${tar_destinationpath}

ssh -p ${remoteport} ${remoteuser}@${remotehost} "find ${tar_destinationpath} -type f -mtime +31 -name *.tar -delete"

# syncronise to remote backup host 
rsync ${rsync_options} -e "ssh -p 2244" ${rsync_sourcepath} ${remoteuser}@${remotehost}:${rsync_destinationpath}