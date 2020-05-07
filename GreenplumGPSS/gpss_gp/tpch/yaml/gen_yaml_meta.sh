if [ $# -ne 2 ] ; then
  echo "======================================="
  echo $0 "TopicName schema.table_name"
  echo "======================================="
  exit
fi

TOPIC=$1
SCHEMATABLE=`echo $2 | awk '{print tolower($1)}'`

GPSS_SCHEMA=gpss_stg
SCHEMA=`echo ${SCHEMATABLE} | awk -F"." '{print $1}'`
TABLE_NAME=`echo ${SCHEMATABLE} | awk -F"." '{print $2}'`
STG_TABLE=stg_${SCHEMA}_${TABLE_NAME}
TMP_TABLE=tmp_${SCHEMA}_${TABLE_NAME}
OUT_YAML=${SCHEMATABLE}.yaml
UDF_NAME=${GPSS_SCHEMA}.udf_sync_${SCHEMA}_${TABLE_NAME}

DBNAME="gpssdb"
USERNAME="gpadmin"
HOST="mdw"
PORT="5432"
BROKERS="172.16.25.227:9092"

cat << + > $OUT_YAML
DATABASE: ${DBNAME}
USER: ${USERNAME}
HOST: ${HOST}
PORT: ${PORT}
KAFKA:
   INPUT:
     SOURCE:
       BROKERS: ${BROKERS} 
       TOPIC: $TOPIC
     COLUMNS:
        - NAME: j
          TYPE: json
     FORMAT: json
     ERROR_LIMIT: 10
   OUTPUT:
     SCHEMA: ${GPSS_SCHEMA}
     TABLE: ${TMP_TABLE}
     MAPPING:
        - NAME: m
          EXPRESSION: j->'metadata'
        - NAME: d
          EXPRESSION: j->'data'
        - NAME: gpss_ts
          EXPRESSION: gpss.json_get_ts_meta (j,'metadata','gpss_ts')
   COMMIT:
      MINIMAL_INTERVAL: 1000
   TASK:
      POST_BATCH_SQL: select ${UDF_NAME}();
      BATCH_INTERVAL: 1
+

echo
echo "==========================================================================================="
echo "Source File :"
ls -l $OUT_YAML
echo "==========================================================================================="
echo
