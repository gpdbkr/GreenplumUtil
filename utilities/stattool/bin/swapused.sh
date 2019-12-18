#!/bin/bash

if [ $# -ne 2 ]
then
/bin/echo "usage is $0 <interval> <count>"
exit 1
fi

i=0
while [ $i -lt $2 ]
do
tm=`date "+%H:%M:%S"`

m1=`free -g | grep Swap | awk '{print $3}'`
m2=`ssh smdw free -g | grep Swap | awk '{print $3}'`
s1=`ssh sdw1 free -g | grep Swap | awk '{print $3}'`
s2=`ssh sdw2 free -g | grep Swap | awk '{print $3}'`
s3=`ssh sdw3 free -g | grep Swap | awk '{print $3}'`
s4=`ssh sdw4 free -g | grep Swap | awk '{print $3}'`
#s5=`ssh sdw5 free -g | grep Swap | awk '{print $3}`
#s6=`ssh sdw6 free -g | grep Swap | awk '{print $3}`
#s7=`ssh sdw7 free -g | grep Swap | awk '{print $3}`
#s8=`ssh sdw8 free -g | grep Swap | awk '{print $3}`

echo "[$tm] $m1,$m2,$s1,$s2,$s3,$s4"
#echo "[$tm] $m1,$m2,$s1,$s2,$s3,$s4,s5,s6,s7,s8"

sleep $1
i=`expr $i + 1`
#echo $i
done
