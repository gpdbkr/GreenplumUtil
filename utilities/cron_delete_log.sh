#!/bin/sh

## statlog(60 days)
find /data/dba/utilities/statlog -mtime +60 -print -exec rm -f {} \; 

## pg_log(60 days)
find /data/master/gpseg-1/pg_log -mtime +60 -print -exec rm -f {} \;
