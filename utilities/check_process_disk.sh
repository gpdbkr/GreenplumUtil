#!/bin/bash

source /home/gpadmin/.bash_profile

DT=`date "+%Y-%m-%d %H:%M:%S"`

Logfile=/data/dba/logs/chk_process_disk_`date +"%Y-%m-%d"`.log


HEADER="=========Date========|===User_Session===|=MB_rd=|==MB_wr=="

#for i in `seq 1 28`
for i in `seq 1 20200`
do
    echo $HEADER | awk -F"|" '{print $1" "$2" \t"$3" \t"$4}' >> $Logfile

    pidstat -dl 4 1 | egrep "PID|con" | grep Average | grep con | grep -v process | awk '{print $9"|"$12" "$3" "$4}' | awk '{kB_rd[$1] += $2/1024}{kB_wr[$1] += $3/1024} END {for ( i in kB_rd) print i"\t" kB_rd[i]"\t"kB_wr[i]}' | awk -F" " '{ if($3>1 || $4>1)print $0}' | awk -v date=`date "+%Y-%m-%d_%H:%M:%S"` '{print date"\t" $0}' >> $Logfile

    sleep 1
done

#summary command sample
#cat chk_process_disk_2019-01-08.log | grep 2019-01-08_20 | awk '{print $2" "$3" "$4}' | awk '{kB_rd[$1] += $2}{kB_wr[$1] += $3} END {for ( i in kB_rd) print i"\t" kB_rd[i]"\t"kB_wr[i]}'

