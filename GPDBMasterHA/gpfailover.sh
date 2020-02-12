#!/bin/bash

## get vip config 
. /usr/local/bin/vip_env.sh

. /usr/local/greenplum-db/greenplum_path.sh
export PGPORT=5432

## killing previous gpfailover daemon
NO_OF_PROCESS=`ps -ef | grep gpfailover.sh | grep -v grep | grep -v status | grep -v stop | wc -l`

if [ $NO_OF_PROCESS -gt 2 ]; then
    exit
fi


while true
do
    POSTGRESCNT=`ps -ef | grep postgres | wc -l`
    if [ $POSTGRESCNT -gt 8 ]
        then
            echo "${GPMDW} was activated !!!"
            exit 0
        else
        echo "${GPSMDW} is standby !!!"
    fi
    
    CNT_A=`ping -c 6 -i 10 ${GPMDW} | grep ", 0% packet loss" | wc -l`
    if [ $CNT_A -eq 1 ]
    then
        echo "alive"
    else
        echo "run gpactivatestandby!!!"
        
        logger -i -p user.emerg "GP:WARNING : GPDB MASTER VM IS NOT AVAILABLE !!!"
        logger -i -p user.emerg "GP:INFO : GPDB STANDBY MASTER IS STARTING TO FAILOVER !!!"
        
        su - gpadmin -c "gpactivatestandby -d /data/master/gpseg-1 -a -q"

        ### Checking the gpactivatestandby.log
        cd /home/gpadmin/gpAdminLogs
        SUCCESS_FG=`ls -lrt gpactivatestandby_*.log | tail -1  | awk '{print $9}' | xargs tail -30 | grep "The activation of the standby master has completed successfully" | wc -l`
        if [ ${SUCCESS_FG} -eq 1 ]
        then 
             logger -i -p user.emerg "GP:INFO : The activation of the standby master has completed successfully "
        else 
             logger -i -p user.emerg "GP:ERROR : Failed the activation of the standby master !!!"
             exit 1
        fi
        

	 ifconfig ${VIP_INTERFACE} ${VIP}  netmask ${VIP_NETMASK} up

        ### Checking VIP
        VIP_FG=`ifconfig | grep ${VIP} | wc -l`
        if [ ${VIP_FG} -eq 1 ]
        then
             logger -i -p user.emerg "GP:INFO : Virtual IP( ${VIP} ) is up  "
        else
             logger -i -p user.emerg "GP:ERROR : Failed to start Virtual IP( ${VIP} ) "
             exit 1
        fi

        ### arping
        arping -f -w 10 -s ${VIP}  -U ${VIP_GW} -I ${ARPING_INTERFACE}
        logger -i -p user.emerg "GP:IFNO : Executed arping."
        logger -i -p user.emerg "GP:INFO : Greenplum master failover has completed successfully "
        exit 0
   	fi
 
    sleep 60
done
exit 0
