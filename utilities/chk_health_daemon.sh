#!/bin/bash

STATUS=`find /data/master/gpseg-1/gpperfmon/data/snmp/snmp*.txt -mmin -5 -print  | wc -l`
#STATUS=0
#echo $STATUS
if [ $STATUS = 0 ];then
	logger -i -p user.emerg "GP:WARNING mdw,healthmond is down,error"
	#echo "GP:WARNING mdw,healthmond is down,error"
fi
