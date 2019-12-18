#!/bin/sh

RMDATE=`date +%Y%m%d --date '30 days ago'`
TODAY=`date +%Y%m%d`


## testdb backup
/bin/date > /data/dba/gpAdminLogs/gp_testdbdump.log

/bin/bash /usr/local/greenplum-db/bin/gpcrondump -x testdb -s edu_sch -d /data/master/gpseg-1  -g -G -u /backup/DCA-01 -a -y /var/tmp -q --rsyncable >> /data/dba/gpAdminLogs/gp_testdbdump.log

/bin/date >> /data/dba/gpAdminLogs/gp_testdbdump.log

# remove previous dump log
rm -rf /backup/DCA-01/db_dumps/$RMDATE
rm -rf /var/tmp/db_dumps/$RMDATE
