if [ $# -ne 2 ] ; then
  echo $0 "jobname tablename.yaml"
  exit
fi




gpsscli submit --name $1 $2 
