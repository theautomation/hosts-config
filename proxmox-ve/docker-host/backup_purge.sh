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
rsync_options="--archive --partial --stats --verbose"
# exclude files and/or folders for rsync
rsync_exclude=
# source path tarball with tar
tar_sourcepath="/home/coen/docker-home-services/adguard-home"
# destination path for tar file
tar_destinationpath="/backup-pool/purge/"
# tar options
tar_options="--create --gzip"
# tar filename
tar_name="$(date '+%y-%m-%d').tar.gz"
# temporary directory for tar file
tar_tempdir="/mnt/slow-storage/temp"


# user of the remote machine
remoteuser="coen"
# ip address of the remote machine
remotehost="192.168.1.234"
# remote ssh port
remoteport="2244"

echo "starting sript..."

# upload tar files to remote backup host and purge old ones
if [ ! -d ${tartempdir} ]; then
  mkdir ${tartempdir}
  echo "created temporary directory for tar file in ${tar_tempdir}"
else 
  echo "no temporary directory is made, it was already there ${tar_tempdir}"
fi

echo "starting tar..."
tar ${tar_options} --file ${tar_tempdir}/${tar_name} ${tar_sourcepath}

echo "start sending tar..."
rsync ${rsync_options} --remove-sent-files -e "ssh -p ${remoteport}" ${tar_tempdir}/*.tar* ${remoteuser}@${remotehost}:${tar_destinationpath}

echo "start deleting old tar on remote machine..."
ssh -p ${remoteport} ${remoteuser}@${remotehost} "find ${tar_destinationpath} -type f -mtime +31 -name *.tar* -delete"