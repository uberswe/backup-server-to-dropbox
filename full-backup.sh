#!/bin/bash

###############################################################################
## Dropbox Uploader location and configuration
###############################################################################
DROPBOX_UPLOADER="/root/backups/dropbox_uploader.sh"
CONFIG_FILE="/root/.dropbox_uploader"

###############################################################################
## File name and directories
###############################################################################
FILE="beubo_backup_$(date +"%Y%m%d%H%M")"
LOCALPATH="/root/backups/${FILE}"
REMOTEPATH="/${FILE}"

###############################################################################
## Information to backup
###############################################################################
BU_FILES="/var/www /root/go/src /etc /home/vhserver"

###############################################################################
## Functions
###############################################################################
function cleanup
{
    # Perform program exit housekeeping
    echo "Removing temporary files..."
    rm -fr ${LOCALPATH}*
    echo "All done."
    exit ${1}
}

function backupDatabase
{
    echo "Creating database backup..."
    if mysqldump -u root --all-databases > ${LOCALPATH}.sql; then
        # add sql dump to files to be compressed
        BU_FILES="${BU_FILES} ${LOCALPATH}.sql"

    else
        echo "Failed to create backup. Aborting..."
        cleanup 1
    fi

}

function backupFiles
{
    echo "Creating files backup..."
    tar cf - ${BU_FILES} | gzip -9 > ${LOCALPATH}.tar.gz

    # check if backup was successfull
    if [ ${PIPESTATUS[0]} -ne "0" ] && [ ${PEPESTATUS[1]} -ne "0" ]; then
        echo "Failed to create backup. Aborting..."
        cleanup 1
    fi
}

function uploadBackup
{
    echo "Uploading to Dropbox..."
    if ${DROPBOX_UPLOADER} -f ${CONFIG_FILE} upload ${LOCALPATH}.tar.gz ${REMOTEPATH}.tar.gz; then
        echo "Backup ${FILE} has been successfully uploaded to Dropbox"
    else
        echo "Failed to upload backup. Aborting..."
    fi
}

###############################################################################
## Run Script
###############################################################################
backupDatabase
backupFiles
uploadBackup
cleanup
