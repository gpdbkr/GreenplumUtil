if [ $# -lt 1 ] ; then
  echo "Usage: " $0 "gpssJobname"
  echo "example: " $0 "tpch.customer"
  exit
fi

case $2 in
e|E)
OPTION='--force-reset-earliest'
;;

l|L)
OPTION='--force-reset-latest'
;;

t|T)
OPTION='--force-reset-timestamp' 
;;

*)
OPTION=''
;;

esac

gpsscli start $1 $OPTION $3
