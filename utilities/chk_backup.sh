#!/bin/sh

TGDATE=`date +%Y%m%d --date '0 days ago'`
echo "DATE:" $TGDATE

TESTDB_TGKEY=`grep -H  "\-\-gp\-c " /var/tmp/db_dumps/$TGDATE/*.rpt | grep testdb |awk -F":" '{print $1}' | tail -1 | awk -F"gp_dump_" '{print $2}' | awk -F".rpt" '{print $1}'`
echo "TESTDB BACKUP KEY:"$TESTDB_TGKEY

TESTDB_RSLT=`ls /var/tmp/db_dumps/$TGDATE/*${TESTDB_TGKEY}*.rpt | tail -1 |xargs tail -1 | awk -F" " '{print $4}'`

if [ $TESTDB_RSLT = "successfully." ]; then
   TESTDB_SUCCESS_YN=Y
else
   TESTDB_SUCCESS_YN=N
fi

echo "TESTDB_SUCCESS_YN:"$TESTDB_SUCCESS_YN

if [ $TESTDB_SUCCESS_YN != Y ]; then
#echo "GP:WARNING testdb,Backup is failed,error"
	logger -i -p user.emerg "GP:WARNING testdb,Backup is failed,error"
	echo ""
fi
