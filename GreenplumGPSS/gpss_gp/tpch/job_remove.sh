if [ $# -ne 1 ] ; then
  echo "Usage: " $0 "gpssJobname"
  echo "example: " $0 "tpch.customer"
  exit
fi
gpsscli remove $1
