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
STG_TABLE=${SCHEMA}_${TABLE_NAME}
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
     TABLE: ${STG_TABLE}
     MAPPING:
+

psql -d ${DBNAME} -AtX << + >> ${OUT_YAML}
select 
       case when typname like '%char%' then     
 	                 '        - NAME: ' || c.attname || '
'                     || '          EXPRESSION: gpss.json2text (j,''' || c.attname || ''')'
	    when typname like '%int%'
              or typname like '%numeric%'			 
	      or typname like '%float%' then 
 	                 '        - NAME: ' || c.attname || '
'                     || '          EXPRESSION: gpss.json2num  (j,''' || c.attname || ''')'
	    when typname like '%date%'
	      or typname like '%time%' then 
 	                 '        - NAME: ' || c.attname || '
'                     || '          EXPRESSION: gpss.json2ts   (j,''' || c.attname || ''')'
	    else 'ERR'
       end typ
  from pg_namespace a 
     , pg_class b 
     , pg_catalog.pg_attribute c 
     , pg_catalog.pg_type d 
where a.oid = b.relnamespace 
  and b.oid = c.attrelid 
  and d.oid = c.atttypid 
  and a.nspname = '${SCHEMA}'
  and b.relname = '${TABLE_NAME}'
  and c.attnum > 0
order by attnum 
+

cat << + >> $OUT_YAML
        - NAME: gpss_ts
          EXPRESSION: gpss.json2ts   (j,'gpss_ts')
        - NAME: gpss_fg
          EXPRESSION: gpss.json2text (j,'gpss_fg')
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
