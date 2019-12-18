#!/bin/sh
LOG_PATH="/data/master/gpseg-1/gpperfmon/data/snmp" 
export LOG_PATH

cd $LOG_PATH
for FILENAME in `ls snmp.host.*.txt`
do
echo $FILENAME
	for i in `grep -v normal ${LOG_PATH}/${FILENAME} | awk -F"|" '{print $2","$5","$7}' | sed 's/ /_/g'`
	do
		## To avoid to log at /var/log/message
		EXCEPT01=`echo $i | awk -F"," '{print $2}'`
		EXCEPT02=`echo $i | awk -F"," '{print $2}'`
              	
		if [ "$EXCEPT01" != "Controller_1_Status" ]&&[ "$EXCEPT02" != "Core_files_on_system" ]; then
			echo "GP:WARNING ${i}"
			logger -i -p user.emerg "GP:WARNING ${i}"
		fi
	done;
done;
