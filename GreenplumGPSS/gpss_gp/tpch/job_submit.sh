if [ $# -ne 1 ] ; then
  echo "Usage: " $0 "gpssJobname"
  echo "example: " $0 "tpch.customer"
  exit
fi
gpsscli submit --name  $1 ./yaml/$1.yaml
