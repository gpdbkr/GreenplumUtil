#!/bin/sh

BASEDATE=`date +%Y%m%d%H`
mkdir -p /data/dba/backup

cp /data/master/gpseg-1/pg_hba.conf /data/dba/backup/pg_hba.conf.$BASEDATE

## delete backup(60 days)
find /data/dba/backup -mtime +60 -print -exec rm -f {} \;
