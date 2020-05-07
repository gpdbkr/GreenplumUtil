if [ $# -ne 2 ] ; then
  echo $0 "TopicName schema.table_name"
  exit
fi

TOPIC=$1
SCHEMATABLE=`echo $2 | awk '{print tolower($1)}'`
SCHEMA=striim=`echo ${SCHEMATABLE} | awk -F"." '{print $1}'`
TARGET_TABLE=`echo ${SCHEMATABLE} | awk -F"." '{print $2}'`
STAGE_TABLE=${TARGET_TABLE}_stg
CDC_TABLE=${TARGET_TABLE}_cdctmp
OUT_YAML=${SCHEMATABLE}.yaml
UDF_NAME=public.cdc_${SCHEMA}_${TARGET_TABLE}

cat << + > $OUT_YAML
DATABASE: pocdb
USER: gpadmin
HOST: devvmdw
PORT: 5432
KAFKA
   INPUT:
     SOURCE:
	    BROKERS: 10.61.160.193:9092
		TOPIC: $TOPIC
	 COLUMNS:
	    - NAME: j
		  TYPE: text
     FORMAT: delimited
	 DELIMITED_OPTION:
	    DELIMITER: "\x03"
	 ERROR_LIMIT: 2
   OUTPUT:
     SCHEMA: $SCHEMA
	 TABLE: $CDC_TABLE
	 MAPPING:
	    - NAME: m
		  EXPRESSION: (substr(j, 2, length("j") -2))::jsonb->'metadata'
		- NAME: d
		  EXPRESSION: (substr(j, 2, length("j") -2))::jsonb->'data'
		- NAME: z_cdc_ts 
		  EXPRESSION: public.cdc_get_ts_md(j, 'metadata', 'TimeStamp')   
   COMMIT:
     MINIMAL_INTERNAL: 1000
   TASK:
	  POST_BATCH_SQL: select $UDF_NAME();
	  BATCH_INTERNAL: 1
	  
+ 



