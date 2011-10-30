#!/bin/sh

##########################################
#  User Configuration                    #
##########################################

# Base directory of this script
BASE_DIR=/home/user/s3bkp/

# Root folder of your web applications
HTTPROOT=/var/www

# MySql root / admin user
MYSQL_USER=root
MYSQL_PW=rootspassword

# S3 Details
S3_ACCESS_KEY=11111111111111
S3_ACCESS_SECRET=secret
S3BUCKET=bucket-name
S3PREFIX=bkp
S3STORE=${S3BUCKET}:${S3PREFIX}

# Backup directorys
BACKUPDIR=${BASE_DIR}backups/
UPLOADDIR=${BASE_DIR}uploads/
SYNCDIR=${BASE_DIR}s3sync/

##########################################
#  End of config                         #
##########################################

# Date stamps
DATE_DAY=`date +%d`
NOW=$(date  +_%b_%d_%y)

# Backup all databases
mysqldump -u ${MYSQL_USER} --password=${MYSQL_PW} --all-databases | bzip2 -c >  all_databases_${DATE_DAY}.sql.bz2

# backup all source files
tar czvfP source_backup_${DATE_DAY}.tar.gz ${HTTPROOT}

# move backups into folder
mv -f all_databases_${DATE_DAY}.sql.bz2 ${BACKUPDIR}
mv -f source_backup_${DATE_DAY}.tar.gz ${BACKUPDIR}

# combine into one
tar czvfP complete_backup_${NOW}.tar.gz ${BACKUPDIR}
mv complete_backup_${NOW}.tar.gz ${UPLOADDIR}

# set envvars for s3sync.rb
export AWS_ACCESS_KEY_ID=${S3_ACCESS_KEY}
export AWS_SECRET_ACCESS_KEY=${S3_ACCESS_SECRET}
export AWS_CALLING_FORMAT=SUBDOMAIN

# move to the ruby sync directory
cd ${SYNCDIR}
./s3sync.rb -r ${UPLOADDIR} ${S3STORE}

# remove files from uploads after they have been transferred to S3
cd ${UPLOADDIR}
rm -rvf *
cd ${BACKUPDIR}
rm -rvf *
cd ${BASE_DIR}