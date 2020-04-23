if [ $# -ne 1 ] ; then
  echo "Usage : " $0 "seq"
  exit
fi
psql -ef tb_demo_cud_src_$1.sql
