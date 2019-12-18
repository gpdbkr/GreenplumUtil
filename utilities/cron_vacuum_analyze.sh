#!/bin/bash

if [ -f /data/dba/.bash_profile ];then
. /data/dba/.bash_profile
fi

DBNAME="gpadmin"
DATE="/bin/date"
ECHO="/bin/echo"
LOGFILE="/data/dba/utilities/log/cron_vacuum_analyze_${DBNAME}_`date '+%Y-%m-%d'`.log"

$ECHO "  CATALOG TABLE VACUUM ANALYZE started at " > $LOGFILE
$DATE >> $LOGFILE 

VCOMMAND="VACUUM ANALYZE"
psql -tc "select '$VCOMMAND' || ' pg_catalog.' || relname || ';' from pg_class a,pg_namespace b where a.relnamespace=b.oid and b.nspname= 'pg_catalog' and a.relkind='r'" $DBNAME | psql -a $DBNAME  >> $LOGFILE

$ECHO "..............................." >> $LOGFILE 
$ECHO "  CATALOG TABLE VACUUM ANALYZE Completed at" >> $LOGFILE
$DATE >> $LOGFILE 


DBNAME="testdb"
LOGFILE="/data/dba/utilities/log/cron_vacuum_analyze_${DBNAME}_`date '+%Y-%m-%d'`.log"

$ECHO "  CATALOG TABLE VACUUM ANALYZE started at " > $LOGFILE
$DATE >> $LOGFILE

VCOMMAND="VACUUM ANALYZE"
psql -tc "select '$VCOMMAND' || ' pg_catalog.' || relname || ';' from pg_class a,pg_namespace b where a.relnamespace=b.oid and b.nspname= 'pg_catalog' and a.relkind='r'" $DBNAME | psql -a $DBNAME  >> $LOGFILE

$ECHO "..............................." >> $LOGFILE
$ECHO "  CATALOG TABLE VACUUM ANALYZE Completed at" >> $LOGFILE
$DATE >> $LOGFILE
