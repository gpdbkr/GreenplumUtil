#!/bin/bash 

MINIO_PID=`cat minio.pid 2> /dev/null`

if [ ! -z $MINIO_PID ]; then
    kill $MINIO_PID    
    rm -f minio.pid
else
    echo "No MINIO processes are currently active."
fi
