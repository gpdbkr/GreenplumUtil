for i in `ls ./gent2/*.yaml`
do
#echo $i
yaml=`echo $i| awk -F"/" '{print $3}'`
jobname=`echo $yaml | sed 's/.yaml//g'`
./$i $jobname $i
done
