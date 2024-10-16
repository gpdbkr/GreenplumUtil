#!/bin/bash 

LOG_FILE="$PWD/logs/minio.`/bin/date '+%Y%m%d'`.log" 

export MINIO_VOLUMES="/data/minio"

export MINIO_ROOT_USER=minioadmin
export MINIO_ROOT_PASSWORD=minioadmin 

#minio server --console-address :9001 $MINIO_VOLUMS  >> $LOG_FILE 2>&1 & 
minio server --console-address :9001 $MINIO_VOLUMS  >> $LOG_FILE 2>&1 & 
#minio server --address :443 --console-address :9001 $MINIO_VOLUMS  >> $LOG_FILE 2>&1 & 

MINIO_PID=$! 

if [ ! -z $MINIO_PID ] ; then
     echo "$MINIO_PID" > minio.pid
fi
