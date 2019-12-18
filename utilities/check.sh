#!/bin/bash

PGDATABASE=$1
export PGDATABASE
export LANG=C

#1.checking file space

echo "================================================================================================================="
echo "1.checking file space"
psql -X <<!
select 
        dfhostname hostname, dfdevice Filesystem,  2877021568/1024/1024 Size_gb
      , (2877021568 - dfspace)/1024/1024 used
      , (dfspace/1024/1024) Avail
      , round((1- dfspace/2877021568::numeric ),2)* 100 "Use%"
      , '70.00' as "Guide%"
from   (
select dfhostname, dfdevice,  dfspace
from  gp_toolkit.gp_disk_free
group by 1,2,3
) a
order by 1,2
!

DBSPACE=`psql -AtXc "select count(*) from (
        select
               dfhostname
             , dfdevice
             , dfspace
          from gp_toolkit.gp_disk_free
         group by 1,2,3
       ) a
 WHERE (1- dfspace/2877021568::numeric )  > 0.7 "`

DBSPACE_MAX=`psql -AtXc "select
        max(\"Use%\")||'%'
  from
(  
select
        dfhostname hostname, dfdevice Filesystem,  2877021568/1024/1024 Size_gb
      , (2877021568 - dfspace)/1024/1024 used
      , (dfspace/1024/1024) Avail
      , round((1- dfspace/2877021568::numeric ),2)* 100 \"Use%\"
      , '70.00' as \"Guide%\"
from  (
select dfhostname, dfdevice,  dfspace
from  gp_toolkit.gp_disk_free
group by 1,2,3
) a
)a"`

if [ $DBSPACE = "0" ]
then
DBSPACE_STATUS=NORMAL
else
DBSPACE_STATUS=WARNING!!
fi
echo $DBSPACE_STATUS
echo "================================================================================================================="
echo
echo

#2. master process
echo "================================================================================================================="
echo "2.GP_MASTER_PROCESS"
GPMPS=`ps -ef | grep postgres | grep -v grep | grep -v con | wc -l`
ps -ef | grep postgres | grep -v grep | grep -v con

if [ $GPMPS = "10" ]
then
GPMPS_STATUS=NORMAL
else
GPMPS_STATUS=WARNING!!
fi
echo $GPMPS_STATUS
echo
echo


3. standby master process
echo "================================================================================================================="
echo "3.GP_STANDBY_PROCESS"
GPSPS=`ssh smdw ps -ef | egrep "gpsyncmaster|postgres" | grep -v egrep | wc -l`
ssh smdw ps -ef | egrep "gpsyncmaster|postgres" | grep -v egrep

if [ $GPSPS = "4" ]
then
GPSPS_STATUS=NORMAL
else
GPSPS_STATUS=WARNING!!
fi
echo $GPSPS_STATUS
echo "================================================================================================================="
echo
echo

#4. query hang
echo "================================================================================================================="
echo "4.QUERY_HANG"

echo "set statement_timeout=10000;
select count(*) from dba.tb_hang_check;" > hang_check.sql

`psql -AtXf hang_check.sql > hang.txt 2>&1`

DBHANG=`cat ./hang.txt| awk '{print $1}'| perl -pi -e "s/SET\n//g"`

if [ $DBHANG = "96" ]
then
DBHANG=NORMAL
else
DBHANG=QUERY_HANG!!
fi
rm hang.txt
rm hang_check.sql

echo $DBHANG
echo "================================================================================================================="
echo
echo

#5. db instance
echo "================================================================================================================="
echo "5. db instance"
DBINSTANCE=`psql -AtXc "select count(*) from gp_segment_configuration where status <> 'u' or (role <> preferred_role);"`
if [ $DBINSTANCE = "0" ]
then
DBINSTANCE_STATUS=NORMAL
else
DBINSTANCE_STATUS=WARNING!!
fi
echo $DBINSTANCE_STATUS
echo "================================================================================================================="
echo
echo


#6. check default partition table
echo "================================================================================================================="
echo "6. check default partition table"
DBPARTITION=`psql -AtXc "select count(*) from dba.v_tb_pt_size  where  tb_pt_nm like '%1_prt_pother%' and tb_kb > 0;"`
if [ $DBPARTITION = "0" ]
then
DBPARTITION_STATUS=NORMAL
else
DBPARTITION_STATUS=WARNING!!
fi
echo $DBPARTITION_STATUS
echo "================================================================================================================="
echo
echo


#7. check db backup
echo "================================================================================================================="
echo "7. check db backup"

TGDATE=`date +%Y%m%d --date '0 days ago'`
#echo "DATE:" $TGDATE

#TGKEY=`ls /var/tmp/db_dumps/$TGDATE/*.rpt | tail -1 | awk -F"gp_dump_" '{print $2}' | awk -F".rpt" '{print $1}'`
TGKEY=`grep -H  "\-\-gp\-c " /var/tmp/db_dumps/$TGDATE/*.rpt | grep ${PGDATABASE} |awk -F":" '{print $1}' | tail -1 | awk -F"gp_dump_" '{print $2}' | awk -F".rpt" '{print $1}'`
#echo "BACKUP KEY:"$TGKEY

echo $TGDATE

#cat /var/tmp/db_dumps/$TGDATE/*${TGKEY}*.rpt | grep successfully
egrep  "\-\-gp\-c ${PGDATABASE}|successfully" /var/tmp/db_dumps/$TGDATE/*${TGKEY}*.rpt

RSLT=`ls /var/tmp/db_dumps/$TGDATE/*${TGKEY}*.rpt | tail -1 | xargs tail -1 | awk -F" " '{print $4}'`

#echo {$RSLT}
if [ $RSLT = "successfully." ]; then
DBDUMP=NORMAL
else
DBDUMP=WARNING!!
fi

echo $DBDUMP
echo "================================================================================================================="


#8. check table bloating
echo "================================================================================================================="
echo "8. check table bloating"
psql -c " select bdinspname schema_nm, bdirelname tb_nm, bdirelpages*32/1024 real_size_mb, bdiexppages*32/1024 exp_size_mb from gp_toolkit.gp_bloat_diag where bdirelpages*32/1024 > 100; "
DBBLOATING=`psql -AtXc "select count(*) from gp_toolkit.gp_bloat_diag where bdirelpages*32/1024 > 100; "`
if [ $DBBLOATING = "0" ]
then
DBBLOATING_STATUS=NORMAL
else
DBBLOATING_STATUS=WARNING!!
fi
echo "================================================================================================================="

#DB status
echo "DB status"
echo "1. DB_SPACE           : " $DBSPACE_STATUS "<MAX:"$DBSPACE_MAX">"
echo "2. GP_MASTER_PROCESS  : " $GPMPS_STATUS   "<"$GPMPS" ea>"
echo "3. GP_STANDBY_PROCESS : " $GPSPS_STATUS   "<"$GPSPS" ea>"
echo "4. QUERY_HANG         : " $DBHANG
echo "5. DB_INSTANCE        : " $DBINSTANCE_STATUS      "<"$DBINSTANCE" ea>"
echo "6. DEFAULT PARTITION  : " $DBPARTITION_STATUS     "<"$DBPARTITION" ea>"
echo "7. DB_BACKUP          : " $DBDUMP
echo "8. TABLE_BLOATING     : " $DBBLOATING_STATUS      "<"$DBBLOATING" ea>"
echo
echo 
echo

#create table dba.tb_hang_check (tmp int);
#insert into dba.tb_hang_check values(generate_series(1, 96));
