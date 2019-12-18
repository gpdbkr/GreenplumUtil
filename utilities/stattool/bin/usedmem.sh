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

let m1=`free -g | grep Mem | awk '{print $3"-"$7}'`
let m2=`ssh smdw free -g | grep Mem | awk '{print $3"-"$7}'`
let s1=`ssh sdw1 free -g | grep Mem | awk '{print $3"-"$7}'`
let s2=`ssh sdw2 free -g | grep Mem | awk '{print $3"-"$7}'`
let s3=`ssh sdw3 free -g | grep Mem | awk '{print $3"-"$7}'`
let s4=`ssh sdw4 free -g | grep Mem | awk '{print $3"-"$7}'`
let s5=`ssh sdw5 free -g | grep Mem | awk '{print $3"-"$7}'`
let s6=`ssh sdw6 free -g | grep Mem | awk '{print $3"-"$7}'`
let s7=`ssh sdw7 free -g | grep Mem | awk '{print $3"-"$7}'`
let s8=`ssh sdw8 free -g | grep Mem | awk '{print $3"-"$7}'`

echo "[$tm] $m1,$m2,$s1,$s2,$s3,$s4"
#echo "[$tm] $m1,$m2,$s1,$s2,$s3,$s4,$s5,$s6,$s7,$s8"

sleep $1
i=`expr $i + 1`
#echo $i
done
