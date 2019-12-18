#!/bin/sh

# source 
. ~/.bash_profile


# nmon log  /data/dba/backup/nmon on the master/standby master
/usr/local/greenplum-db/bin/gpssh -h mdw -h smdw "cd /data/dba/backup/nmon;nmon -fT -s 30 -c 2820"
/usr/local/greenplum-db/bin/gpssh -h mdw -h smdw "find /data/dba/backup/nmon -mtime +70 -print -exec rm -f {} \;" 


# nmon log /data/dba/backup/nmon on the segments
/usr/local/greenplum-db/bin/gpssh -h sdw1 -h sdw2 -h sdw3 -h sdw4 -h sdw5 -h sdw6 -h sdw7 -h sdw8 -h sdw9 -h sdw10 -h sdw11 -h sdw12 -h sdw13 -h sdw14 -h sdw15 -h sdw16 "cd /data/dba/backup/nmon;nmon -fT -s 30 -c 2820"

/usr/local/greenplum-db/bin/gpssh -h sdw1 -h sdw2 -h sdw3 -h sdw4 -h sdw5 -h sdw6 -h sdw7 -h sdw8 -h sdw9 -h sdw10 -h sdw11 -h sdw12 -h sdw13 -h sdw14 -h sdw15 -h sdw16 "find /data/dba/backup/nmon -mtime +70 -print -exec rm -f {} \;"
