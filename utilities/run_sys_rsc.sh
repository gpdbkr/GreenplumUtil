#!/bin/bash
 if [ $# -ne 2 ]; then
     echo "Usage: `basename $0` <interval seconds> <repeate count> "
     echo "Example for run : `basename $0` 2 5 "
     exit
 fi

 SLEEP=`expr $1 - 1`
 TCNT=$2
 CNT_SEG=2          ##### The count of segment nodes, you can edit the number. local team applied to  max 76 




 for ((j=0;j<$TCNT;j++))
 do
     ## Extracted dstat from mdw, smdw and segments node
     ssh mdw  "dstat -tcdnm 1 1" | tail -1 > /tmp/rsc_mdw.txt &
     ssh smdw "dstat -tcdnm 1 1" | tail -1 > /tmp/rsc_smdw.txt &
     for ((i=1;i<=$CNT_SEG;i++))
     do
         ssh sdw$[i] "dstat -tcdnm 1 1" | tail -1 > "/tmp/rsc_sdw"$[i]".txt" &
     done
     wait

     ## Added Space when the count of segments is under 10
     if [ $CNT_SEG -gt 10 ];then
         SPACE=' '
     else
         SPACE=''
     fi

     TIME=`date '+%Y%m%d %H:%M:%S'`
     echo ""
     echo $TIME"                                                           Pivotal Greenplum  "
     echo "        "$SPACE"-------------------------------------- Master Node -----------------------------------"
     echo "        "$SPACE"----system---- ----total-cpu-usage---- -dsk/total- -net/total- ------memory-usage-----"
     echo "        "$SPACE"  date/time   |usr sys idl wai hiq siq| read  writ| recv  send| used  buff  cach  free"

     mdw=`cat /tmp/rsc_mdw.txt|sed 's/ /_/g'`
     smdw=`cat /tmp/rsc_smdw.txt|sed 's/ /_/g'`
     echo "["$SPACE" mdw]  "$mdw  | sed 's/_/ /g'
     echo "["$SPACE"smdw]  "$smdw | sed 's/_/ /g'

     echo "        "$SPACE"------------------------------------- Segment Node -----------------------------------"
     echo "        "$SPACE"----system---- ----total-cpu-usage---- -dsk/total- -net/total- ------memory-usage-----"
     echo "        "$SPACE"  date/time   |usr sys idl wai hiq siq| read  writ| recv  send| used  buff  cach  free"

     for ((i=1;i<=$CNT_SEG;i++))
     do
         ## Added Space when the count of segments is under 10
         if ([ $CNT_SEG -gt 10 ] && [ $i -lt 10 ]);then
             SPACE='0'
         else
             SPACE=''
         fi

         sdw[i]="`cat /tmp/rsc_sdw${i}.txt|sed 's/ /_/g'`"
         echo "[sdw"${SPACE}${i}"]  "${sdw[i]}| sed 's/_/ /g'
     done
     sleep $SLEEP
 done

