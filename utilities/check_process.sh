#!/bin/bash


DT=`date "+%Y-%m-%d %H:%M:%S"`

Logfile=/data/dba/logs/chk_process_`date +"%Y-%m-%d"`.log


HEADER="=========Date========|===Session===|=Pcnt=|==Cpu==|==Mem==|==VSZ==|==RSS=="

for i in `seq 1 28`
do
    echo $HEADER | awk -F"|" '{print $1" "$2" "$3" "$4" "$5"\t"$6"\t\t"$7}' >> $Logfile
#    ps auxwww | grep gpadmin | grep postgres | grep con | grep -v grep | awk '{cpu[$17] += $3}{ cnt[$17] += 1}{mem[$17] += $4}  END {for ( i in cpu) print i"\t" cnt[i]"\t"cpu[i]"\t"mem[i]}' | awk -F" " '{ if($2>10 || $3>100 || $4>10)print $0}' | awk -v date=`date "+%Y-%m-%d_%H:%M:%S"` '{print date"\t" $0}' >> $Logfile
    ps auxwww | grep gpadmin | grep postgres | grep con | grep -v grep | awk '{cpu[$17] += $3}{ cnt[$17] += 1}{mem[$17] += $4}{vsz[$17] += $5}{rss[$17] += $6} END {for ( i in cpu) print i"\t" cnt[i]"\t"cpu[i]"\t"mem[i]"\t"vsz[i]"\t"rss[i]}' | awk -F" " '{ if($2>10 || $3>100 || $4>0)print $0}' | awk -v date=`date "+%Y-%m-%d_%H:%M:%S"` '{print date"\t" $0}' >> $Logfile

    echo 

    sleep 2
done
