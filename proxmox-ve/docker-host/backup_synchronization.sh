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

## rsync variables for synchronization
# rsync source path being copied
rsync_sourcepath="/mnt/slow-storage/coen
                  /mnt/slow-storage/anne"
# destination path for rsync
rsync_destinationpath="/backup-pool/rsync"
# rsync options
rsync_options="--archive --partial --stats --verbose"
# exclude files and/or folders for rsync
rsync_exclude=

# user of the remote machine
remoteuser="coen"
# ip address of the remote machine
remotehost="192.168.1.234"
# remote ssh port
remoteport="2244"

echo "starting sript..."

# syncronise to remote backup host 
rsync ${rsync_options} -e "ssh -p 2244" ${rsync_sourcepath} ${remoteuser}@${remotehost}:${rsync_destinationpath}