#!/bin/bash

. /home/gpadmin/.bashrc
cd /data/dba/utilities

psql -c "select count(*) from public.health_check;" -d gpperfmon > chk_health.out 2>&1 

VCNT=`cat chk_health.out | grep "ERROR:  failed to acquire resources on one or more segments" | wc -l`
#echo ${VCNT}

if [ ${VCNT} -eq 0 ]
then
   exit 0  
else
   ##logger -i -p user.emerg "GP:ERROR failed to acquire resources on one or more segments"
   echo ""
fi


gpstate -s > chk_gpstate_s.out 2>&1
cat chk_gpstate_s.out | egrep -B8 "Unknown -- unable to load segment status|Process error -- database process may be down" | grep Hostname | awk -F"=" '{print $2}' | sort | uniq > chk_ping_node.txt


## Waiting for some seconds..
sleep 1

PING_TOT_CHK_NODE=`cat chk_ping_node.txt| wc -l`
echo "Down system nodes: " ${PING_TOT_CHK_NODE}
echo "Below are suspcious nodes"
cat chk_ping_node.txt 

CHK_TOT_CNT=1000
CHK_CNT=0

for i in `seq 1 ${CHK_TOT_CNT}`
do
    CHK_CNT=$i
    #echo "Checking ping :" $i "times"
    PING_TOT_SUCCESS_CNT=0
    PING_SUCCESS_CNT=0

    for VNODE in `cat chk_ping_node.txt`
    do
        echo "Checking "${VNODE} ": " $i "times of " ${CHK_TOT_CNT}
        PING_SUCCESS_CNT=`ping -c 1 -i 1 ${VNODE} | grep ", 0% packet loss" | wc -l`
        PING_TOT_SUCCESS_CNT=`expr ${PING_TOT_SUCCESS_CNT} + $PING_SUCCESS_CNT`;
    done

    if [ ${PING_TOT_CHK_NODE} -eq ${PING_TOT_SUCCESS_CNT} ]
    then 
        echo "The down nodes are alive !!!"
        echo "Next Step...."
        break 
    else
        if [ ${CHK_TOT_CNT} -eq ${CHK_CNT} ]
        then 
             echo "The "${VNODE}" is still down."
             logger -i -p user.emerg "GP:ERROR Greenplum failed to restart !!!"
             exit 
        fi 
    fi
done

echo "Restarting Greenplum cluster!!!!!!!!!!!!"
gpstop -af >> chk_health.out 2>&1 
VCNT=`cat chk_health.out  | grep "Cleaning up leftover shared memory" | wc -l`
logger -i -p user.emerg "GP:WARNING Greenplum was stopped."


logger -i -p user.emerg "GP:WARNING Greenplum is starting"
gpstart -a >> chk_health.out 2>&1 
VCNT=`cat chk_health.out | grep  "Database successfully started" | wc -l`

if [ ${VCNT} -eq 1 ]; then
logger -i -p user.emerg "GP:INFO Greenplum was restarted."
echo ""
fi



## psql gpperfmon
## create table public.health_check ( i int);
## insert into public.health_check  select i from generate_series(1, 20);
