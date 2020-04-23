if [ $# -ne 2 ] ; then
  echo "Usage: " $0 "update|upsert seq"
  exit
fi

psql -ef tb_demo_cud_stg_$2.sql
./call_udf_$1.sh
