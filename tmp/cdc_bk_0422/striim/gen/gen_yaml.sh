/home/gpadmin/pivotal/cdc/striim/gen/gen_udf.sh

TOPIC=test.CmsIm_TableTopic
SCHEMA_NAME=striim
TARGET_TABLE=cms_im_lothold_his_ic
STAGE_TABLE=${TARGET_TABLE}_stg
OUT_YAML=out.yaml

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
	 ERRO_LIMIT: 2
   OUTPUT:
     SCHEMA: $SCHEMA
	 TABLE: $STAGE_TABLE
	 MAPPING:
+

psql pocdb -A -t -X << + >> $OUT_YAML
select --a.fg, attname
         case when a.fg = 1 then '
		      when a.fg = 2 then '
		  end aa
from (
       select fg
	     from (
		        select 1::int fg
				 union all
				select 2::int
			  ) a
	 ) a,
	 (
	    select 1::int fg, c.* 
		  from pg_namespace a 
		     , pg_class b
			 , pg_catalog.pg_attribute c
		 where a.oid = b.relnamespace 
		   and b.oid = c.attrelid
		   and b.relname = 'cms_im_lothold_his_ic'
		   and a.nspname = 'striim'
		   and c.attnum > 0
	 ) b
order by b.attnum, a.fg ;
+

cat << + >> $OUT_YAML
   	    - NAME: z_cdc_ts
		  EXPRESSION: public.strimm_get_timestamp(j, 'metadata', 'TimeStamp') 
		- NAME: z_cud_fg
		  EXPRESSION: public.strimm_get_text(j, 'metadata', 'OperationName')   
   COMMIT:
     MINIMAL_INTERNAL: 1000
   TASK:
	  POST_BATCH_SQL: select udf_${TARGET_TABLE}();
	  BATCH_INTERNAL: 1
	  
+ 



