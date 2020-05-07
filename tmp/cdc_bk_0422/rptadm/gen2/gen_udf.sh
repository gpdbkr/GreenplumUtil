if [ $# -ne 1 ] ; then
  echo $0 "schema.table_name"
  exit
fi

SCHEMATABLE=`echo $1 | awk '{print tolower($1)}'`
SCHEMA_NAME=`echo ${SCHEMATABLE} | awk -F"." '{print $1}'`
TABLE_NAME=`echo ${SCHEMATABLE}  | awk -F"." '{print $2}'`
UDF_NAME="public.cdc_"${SCHEMA_NAME}_${TABLE_NAME}

COLUMN_FILE="template_col.txt"

TARGET_TABLE=${SCHEMA_NAME}.${TABLE_NAME}
STAGE_TABLE=${TARGET_TABLE}_stg
CDC_TABLE=${TARGET_TABLE}_cdctmp
OUTFILE=${UDF_NAME}.sql

psql -d pocdb -AtX << !
\o $COLUMN_FILE
--\o /dev/null
with tmp as (
 select column_name
   from information_schema.table_constraints tc,
	    information_schema.key_column_usage kc
  where  kc.table_schema = '$SCHEMA_NAME'
    and	 kc.table_name = '%TABLE_NAME'
    and  tc.constraint_type = 'PRIMARY KEY'
    and	 kc.table_name = tc.table_name
    and  kc.table_schema = tc.table_schema
    and	 kc.constraint_name	= tc.constraint_name
 )
 select 'P '||column_name
   from tmp
 union
 select 'C '||column_name
   from (
		select column_name 
		  from information_schema.columns 
		 where table_name = '$TABLE_NAME' 
		   and table_schema = '$SCHEMA_NAME'
		except
		select column_name 
		  from tmp
	    ) a
 order by 1 desc
!

PKCOLS=`cat ${COLUMN_FILE} | grep "^P " | awk '{printf ",%s",$2}' | awk '{print substr($1,2)}'`

cat << + > ${OUTFILE}
CREATE OR REPLACE FUNCTION ${UDF_NAME}() RETURNS text AS 
\$\$
DECLARE
		v_target_tb		varchar(64);
		v_del_cnt		integer :=0 ;
		v_ins_cnt		integer :=0 ;
		v_up_cnt		integer :=0 ;
		
		v_min_ts		timestamp;
		v_max_ts		timestamp;
		v_start_ts		timestamp;
		v_end_ts		timestamp;
		
		v_result 		text;
		v_err_msg		text;
		v_cdc_row_cnt   integer	:=0 ;
BEGIN

v_start_ts	:= clock_timestamp();
v_target_tb	:= '${TARGET_TABLE}';

set random_page_cost = 1;
set enable_nestloop = on;

/*
SELECT  min(z_cdc_ts) min_ts max(z_cdc_ts) max_ts into v_min_ts, v_max_ts
  from (
  select z_cdc_ts
    from ${CDC_TABLE}
   order by z_cdc_ts
limit v_rows   
) a ; 
*/

SELECT  min(z_cdc_ts), max(z_cdc_ts) into v_min_ts, v_max_ts
  from ${CDC_TABLE}
  
INSERT INTO ${STAGE_TABLE}
SELECT 
+


psql -d pocdb -AtX << + >> ${OUTFILE}

 select 
        case when typname like '%char%' then     
				  else when c.attnum = 1 then
			           '       public.cdc_get_text (d,''' || upeer(c.attnmae || ''')'
			      else 
			                 , public.cdc_get_text (d,''' || upeer(c.attnmae || ''')'
			      end 
			 when typname like '%int%'
               or typname like '%numeric%'			 
		       or typname like '%float%' then 
                  case when c.attnum = 1 then 
                       '       public.cdc_get_num   (d,''' || upper(c.attname) || ''')'
                  else					   
			           '       public.cdc_get_num   (d,''' || upper(c.attname) || ''')'
			      end
		     when typname like '%date%'
			   or typbane like '%time%' then 
			      case when c.attnum = 1 then 
				       '       public.cdc_get_ts    (d,''' || upper(c.attname) || ''')'
			      else
				       '       public.cdc_get_ts    (d,''' || upper(c.attname) || ''')'
			      end 
		     else 'ERR'
			 end typ
 from pg_namespace a 
    , pg_class b 
	, pg_catalog.pg_attribute c 
	, pg_catalog.pg_type d 
where a.oid = b.relnamespace 
  and b.oid = c.attrelid 
  and d.oid = c.attypid 
  and a.nspname = '${SCHEMA_NAME}'
  and b.relname = '${TABLE_NAME}'
  and c.attnum > 0
order by attnum 

+

cat  << + >> ${OUTFILE}
     , z_cdc_ts
	 , public.cdc_get_text (m, 'OperationName')
  from ${CDC_TABLE}
 WHERE z_cdc_ts >= v_min_ts
   AND z_cdc_ts <= v_max_ts 
;

delete from ${STAGE_TABLE} a
 using ${STAGE_TABLE| b 
+

##### PK ##########################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf " where a.%-25s = b.%-25s\n",$2,$2}' >> ${OUTFILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "   AND a.%-25s = b.%-25s\n",$2,$2}' >> ${OUTFILE}
###################################

cat  << + >> ${OUTFILE}
   AND b.z_cud_fg = 'DELETE'
   AND b.z_cdc_ts >= v_min_ts
   AND b.z_cdc_ts <= v_max_ts;
   
GET DIAGNOSTICS v_del_cnt = ROW_COUNT;

INSERT INTO ${TARGET_TABLE}
(
+

#####  ALL COLUMN LIST ############
cat $COLUMN_FILE | head -1       | awk '{printf "  %s\n",$2}' >> ${OUTFILE}
cat $COLUMN_FILE | sed -n '2,$p' | awk '{printf ", %s\n",$2}' >> ${OUTFILE}
###################################

cat  << + >> ${OUTFILE}
)
WITH tmp AS
(	 
     SELECT *
       FROM (
	         SELECT
+

#####  ALL COLUMN LIST ############
cat $COLUMN_FILE | head -1       | awk '{printf "                     %s\n",$2}' >> ${OUTFILE}
cat $COLUMN_FILE | sed -n '2,$p' | awk '{printf "                   , %s\n",$2}' >> ${OUTFILE}
###################################

cat  << + >> ${OUTFILE}
                   , z_cdc_ts
                   , z_cud_fg
 		           , row_number() over (partition by ${PKCOLS}
	       	                                order by z_cdc_ts desc) rnk
	            from ${STAGE_TABLE} a
               where a.z_cud_fg in ('INSERT','DELETE')
                 and z_cdc_ts >= v_min_ts
	             and z_cdc_ts <= v_max_ts
               ) a
       where z_cud_fg = 'INSERT'
         and rnk = 1
)
select
+

#####  ALL COLUMN LIST ############
cat $COLUMN_FILE | head -1       | awk '{printf "       a.%s\n",$2}' >> ${OUTFILE}
cat $COLUMN_FILE | sed -n '2,$p' | awk '{printf "     , a.%s\n",$2}' >> ${OUTFILE}
###################################

cat  << + >> ${OUTFILE}
  from tmp a
  left outer join ${TARGET_TABLE} b
+

##### PK ##########################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf "    on a.%-25s = b.%-25s\n",$2,$2}' >> ${OUTFILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "   and a.%-25s = b.%-25s\n",$2,$2}' >> ${OUTFILE}
###################################

##### PK ##########################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf " where b.%-25s is null\n",$2}' >> ${OUTFILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "   and b.%-25s is null\n",$2}' >> ${OUTFILE}
###################################

cat  << + >> ${OUTFILE}
;

GET DIAGNOSTICS v_ins_cnt = ROW_COUNT;

WITH tmp AS
(	 
     SELECT *
       FROM (
	         SELECT
+
##### PK ##########################################################################################################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf "                          %-25s\n",$2}' >> ${OUTFILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "                        , %-25s\n",$2}' >> ${OUTFILE}
###################################################################################################################

##### UPDATE COLUMN #############################################################################################################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf "                        , max(%-25s) %-25s\n",$2,$2}' >> ${OUTFILE}
#################################################################################################################################

cat  << + >> ${OUTFILE}
           from (
		         select
				 
+

##### PK ##########################################################################################################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf "                          %-25s\n",$2}' >> ${OUTFILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "                        , %-25s\n",$2}' >> ${OUTFILE}
###################################################################################################################

#id

#### UPDATE COLUMNS ########################
for col in `cat $COLUMN_FILE | grep "^C " | awk '{printf $2}'`
do
cat  << + >> ${OUTFILE}
                      , last_value (${col})
		                      over (partition by ${PKCOLS}
			                            order by case when ${col}
				                                   is not null then 1 else 0 end asc
				                               , z_cdc_ts rows between unbounded preceding
                                                                   and unbounded following) ${col}											   
+
done

cat  << + >> ${OUTFILE}
	            from ${STAGE_TABLE} a
               where a.z_cud_fg in ('UPDATE','INSERT')
                 and z_cdc_ts >= v_min_ts
	             and z_cdc_ts <= v_max_ts
               ) a
          group by ${PKCOLS}
      ) tmp 
)
update ${TARGET_TABLE} a 
   set 
+

#### UPDATE COLUMNS ########################				 
cat $COLUMN_FILE | grep "^C " | head -1       | awk '{printf "        %-25s = coalesce (b.%s, a.%s)\n",$2,$2,$2}' >> ${OUTFILE}
cat $COLUMN_FILE | grep "^C " | sed -n '2,$p' | awk '{printf "      , %-25s = coalesce (b.%s, a.%s)\n",$2,$2,$2}' >> ${OUTFILE}
############################################

cat  << + >> ${OUTFILE}
  frm tmp b 
+

##### PK ##########################################################################################################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf " where a.%-25s = b.%-25s\n",$2,$2}' >> ${OUTFILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "   and a.%-25s = b.%-25s\n",$2,$2}' >> ${OUTFILE}
###################################################################################################################

cat  << + >> ${OUTFILE}
   and (
+
#### UPDATE COLUMNS ########################				 
cat $COLUMN_FILE | grep "^C " | head -1       | awk '{printf "        a.%-25s <> b.%-25s\n",$2,$2}' >> ${OUTFILE}
cat $COLUMN_FILE | grep "^C " | sed -n '2,$p' | awk '{printf "     or a.%-25s <> b.%-25s\n",$2,$2}' >> ${OUTFILE}
############################################

cat  << + >> ${OUTFILE}
       )
;

GET DIAGNOSTICS v_up_cnt = ROW_COUNT;

v_end_ts    :=  clock_timestamp();

INSERT INTO public.cdc_log_chekc
       (target_tb, start_ts, end_ts, stag_rows, ins_cnt, del_cnt, up_cnt)
select v_target_tb, v_start_ts, v_end_ts, sum(cnt) t_cnt, 
       sum(case when z_cud_fg = 'INSERT' then cnt end) ins_cnt,
	   sum(case when z_cud_fg = 'INSERT' then cnt end) ins_cnt,
	   sum(case when z_cud_fg = 'INSERT' then cnt end) ins_cnt,
  from (	   
	   select z_cud_fg, count(*) cnt 
        from ${STAGE_TABLE}
group by z_cud_fg 
) a ;

delete from ${CDC_TABLE}
 where z_cdc_ts >= v_min_ts
   and z_cdc_ts <= v_max_ts
;

delete from ${STAGE_TABLE}
 where z_cdc_ts >= v_min_ts
   and z_cdc_ts <= v_max_ts
;		

GET DIAGNOSTICS v_cdc_row_cnt = ROW_COUNT;

INSERT INTO public.cdc_log (target_tb, start_ts, end_ts, stag_rows, ins_cnt, del_cnt, up_cnt)
VALUES (v_target_tb, v_start_ts, v_end_ts, v_cdc_row_cnt, v_ins_cnt, v_del_cnt, v_up_cnt);

v_result    := 'Start: '||to_char(v_start_ts, 'yyyy-mm-dd hh24:mi:ss')||', '||
                 'End: '||to_char(v_end_ts,   'yyyy-mm-dd hh24:mi:ss') ||', '||
                'Rows: '||trim(to_char(v_cc_row_cnt,  '999,999,999,999'))||', '||
	          'Insert: '||trim(to_char(v_ins_cnt,     '999,999,999,999'))||', '||
	          'Delete: '||trim(to_char(v_del_cnt,     '999,999,999,999'))||', '||
	          'Update: '||trim(to_char(v_up_cnt,      '999,999,999,999')) ; 

RAISE notice '%', v_result;

return v_result;

EXCEPTION
WHEN others THEN
     v_err_msg := sqlerrm;
     RAISE NOTICE 'ERROR_MSG : %' , v_err_msg;
return sqlerrm;

END;
\$\$
LANGUAGE plpgsql NO SQL;
+

echo
ls -l $OUTFILE
echo
echo "Please execute : psql -d pocdb -f "$OUTFILE