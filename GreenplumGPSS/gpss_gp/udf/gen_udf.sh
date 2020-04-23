if [ $# -ne 1 ] ; then
  echo "======================================="
  echo $0 "schema.table_name"
  echo "======================================="
  exit
fi

SCHEMATABLE=`echo $1 | awk '{print tolower($1)}'`

DBNAME="gpssdb"
GPSS_SCHEMA=gpss_stg
SCHEMA=`echo ${SCHEMATABLE} | awk -F"." '{print $1}'`
TABLE_NAME=`echo ${SCHEMATABLE} | awk -F"." '{print $2}'`
TARGET_TABLE="${SCHEMA}.${TABLE_NAME}"
STG_TABLE="${GPSS_SCHEMA}.${SCHEMA}_${TABLE_NAME}"
UDF_NAME="${GPSS_SCHEMA}.udf_sync_${SCHEMA}_${TABLE_NAME}"
OUT_FILE="${UDF_NAME}.sql"
COLUMN_FILE="template_col.txt"

psql -d ${DBNAME} -AtX << !
\o $COLUMN_FILE
with tmpkey as (
 select column_name
   from information_schema.table_constraints tc,
        information_schema.key_column_usage kc
  where kc.table_schema    = '$SCHEMA'
    AND kc.table_name      = '$TABLE_NAME'
    AND tc.constraint_type = 'PRIMARY KEY'
    AND kc.table_name      = tc.table_name
    AND kc.table_schema    = tc.table_schema
    AND kc.constraint_name = tc.constraint_name
    AND column_name not like 'gpss_%'
 ),
tmpcol as (
 SELECT c.attname, c.attnum
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
),
tmp as (
SELECT 'P' as key, column_name as column_name, c.attnum as attnum
  FROM tmpkey k JOIN tmpcol c
    ON k.column_name = c.attname
 UNION
SELECT 'C', c.attname as column_name, c.attnum
  FROM tmpcol c
  LEFT OUTER JOIN tmpkey k
    ON c.attname = k.column_name
 WHERE k.column_name is null
)
SELECT key || ' ' || column_name
  FROM tmp
 ORDER BY attnum
!

PKCOLS=`cat ${COLUMN_FILE} | grep "^P " | awk '{printf ",%s",$2}' | awk '{printf substr($1,2)}'`

cat << + > ${OUT_FILE}
CREATE OR REPLACE FUNCTION ${UDF_NAME}() RETURNS text AS
\$\$
DECLARE
        v_target_tb     varchar(64);
        v_del_cnt       integer :=0 ;
        v_ins_cnt       integer :=0 ;
        v_up_cnt        integer :=0 ;

        v_min_ts        timestamp;
        v_max_ts        timestamp;
        v_start_ts      timestamp;
        v_end_ts        timestamp;

        v_result        text;
        v_err_msg       text;
        v_cdc_row_cnt   integer :=0 ;
BEGIN

v_start_ts    := clock_timestamp();
v_target_tb   := '${TARGET_TABLE}';

set random_page_cost = 1;
set enable_nestloop = on;

SELECT MIN(gpss_ts), MAX(gpss_ts) INTO v_min_ts, v_max_ts
  FROM ${STG_TABLE};

DELETE FROM ${TARGET_TABLE} a
 USING ${STG_TABLE} b
+

#### PK ########################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf " where a.%-25s = b.%-25s\n",$2,$2}' >> ${OUT_FILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "   AND a.%-25s = b.%-25s\n",$2,$2}' >> ${OUT_FILE}
################################

cat << + >> ${OUT_FILE}
   AND b.gpss_fg = 'D'
   AND b.gpss_ts >= v_min_ts
   AND b.gpss_ts <= v_max_ts;

GET DIAGNOSTICS v_del_cnt = ROW_COUNT;

INSERT INTO ${TARGET_TABLE}
(
+

#####  ALL COLUMN LIST ############
cat $COLUMN_FILE | head -1       | awk '{printf "  %s\n",$2}' >> ${OUT_FILE}
cat $COLUMN_FILE | sed -n '2,$p' | awk '{printf ", %s\n",$2}' >> ${OUT_FILE}
###################################

cat << + >> ${OUT_FILE}
)
WITH tmp AS
(
     SELECT *
       FROM (
             SELECT
+

#####  ALL COLUMN LIST ############
cat $COLUMN_FILE | head -1       | awk '{printf "                     %s\n",$2}' >> ${OUT_FILE}
cat $COLUMN_FILE | sed -n '2,$p' | awk '{printf "                   , %s\n",$2}' >> ${OUT_FILE}
###################################

cat << + >> ${OUT_FILE}
                   , gpss_ts
                   , gpss_fg
                   , row_number() over (partition by ${PKCOLS}
                                            order by gpss_ts desc) rnk
               from ${STG_TABLE} a
              where a.gpss_fg in ('I','D')
                and a.gpss_ts >= v_min_ts
                and a.gpss_ts <= v_max_ts
             ) a
       where gpss_fg = 'I'
         and rnk = 1
)
select
+

#####  ALL COLUMN LIST ############
cat $COLUMN_FILE | head -1       | awk '{printf "       a.%s\n",$2}' >> ${OUT_FILE}
cat $COLUMN_FILE | sed -n '2,$p' | awk '{printf "     , a.%s\n",$2}' >> ${OUT_FILE}
###################################

cat << + >> ${OUT_FILE}
  from tmp a
  left outer join ${TARGET_TABLE} b
+

#### PK ########################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf "    on a.%-25s = b.%-25s\n",$2,$2}' >> ${OUT_FILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "   and a.%-25s = b.%-25s\n",$2,$2}' >> ${OUT_FILE}
################################

#### PK ########################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf " where b.%-25s is null\n",$2}' >> ${OUT_FILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "   and b.%-25s is null\n",$2}' >> ${OUT_FILE}
################################

cat << + >> ${OUT_FILE}
;

GET DIAGNOSTICS v_ins_cnt = ROW_COUNT;

WITH tmp AS
(
     SELECT *
       FROM (
             SELECT
+
#### PK ########################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf "                   %-25s\n",$2}' >> ${OUT_FILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "                 , %-25s\n",$2}' >> ${OUT_FILE}
##################################

#### UPDATE COLUMNS ##############
cat $COLUMN_FILE | grep "^C "                 | awk '{printf "                 , max(%-25s) %-25s\n",$2,$2}' >> ${OUT_FILE}
##################################

cat << + >> ${OUT_FILE}
              from (
                     select
+

#### PK ########################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf "                              %-25s\n",$2}' >> ${OUT_FILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "                            , %-25s\n",$2}' >> ${OUT_FILE}
################################

#id

#### UPDATE COLUMNS ########################
for col in `cat $COLUMN_FILE | grep "^C " | awk '{print $2}'`
do
cat  << + >> ${OUT_FILE}
                            , last_value (${col})
                                    over (partition by ${PKCOLS}
                                              order by case when ${col}
                                                                 is not null then 1 else 0 end asc
                                                     , gpss_ts rows between unbounded preceding
                                                                        and unbounded following) ${col}
+
done

cat  << + >> ${OUT_FILE}
                       from ${STG_TABLE}
                      where gpss_fg in ('U','I')
                        AND gpss_ts >= v_min_ts
                        AND gpss_ts <= v_max_ts
                    ) a
               group by ${PKCOLS}
            ) tmp
)
update ${TARGET_TABLE} a
   set
+

#### UPDATE COLUMNS ########################
cat $COLUMN_FILE | grep "^C " | head -1       | awk '{printf "        %-25s = coalesce (b.%s, a.%s)\n",$2,$2,$2}' >> ${OUT_FILE}
cat $COLUMN_FILE | grep "^C " | sed -n '2,$p' | awk '{printf "      , %-25s = coalesce (b.%s, a.%s)\n",$2,$2,$2}' >> ${OUT_FILE}
############################################

cat  << + >> ${OUT_FILE}
  from tmp b
+

#### PK ########################
cat $COLUMN_FILE | grep "^P " | head -1       | awk '{printf " where a.%-25s = b.%-25s\n",$2,$2}' >> ${OUT_FILE}
cat $COLUMN_FILE | grep "^P " | sed -n '2,$p' | awk '{printf "   and a.%-25s = b.%-25s\n",$2,$2}' >> ${OUT_FILE}
################################

cat  << + >> ${OUT_FILE}
   and (
+
#### UPDATE COLUMNS ########################
cat $COLUMN_FILE | grep "^C " | head -1       | awk '{printf "        a.%-25s <> b.%-25s\n",$2,$2}' >> ${OUT_FILE}
cat $COLUMN_FILE | grep "^C " | sed -n '2,$p' | awk '{printf "     or a.%-25s <> b.%-25s\n",$2,$2}' >> ${OUT_FILE}
############################################

cat  << + >> ${OUT_FILE}
       )
;

GET DIAGNOSTICS v_up_cnt = ROW_COUNT;

v_end_ts    :=  clock_timestamp();

INSERT INTO gpss.gpss_udf_exec_log
(       target_tb
      , start_ts
      , end_ts
      , stg_tot_cnt
      , stg_ins_cnt
      , stg_del_cnt
      , stg_up_cnt
      , tgt_ins_cnt
      , tgt_del_cnt
      , tgt_up_cnt 
)
select v_target_tb
     , v_start_ts
     , v_end_ts
     , sum(cnt) t_cnt
     , sum(case when gpss_fg = 'I' then cnt end) stg_ins_cnt
     , sum(case when gpss_fg = 'D' then cnt end) stg_del_cnt
     , sum(case when gpss_fg = 'U' then cnt end) stg_up_cnt
     , v_ins_cnt
     , v_del_cnt
     , v_up_cnt
  from (	   
         select gpss_fg, count(*) cnt 
           from ${STG_TABLE}
          where gpss_ts >= v_min_ts
            and gpss_ts <= v_max_ts
          group by gpss_fg 
       ) a ;

delete from ${STG_TABLE}
 where gpss_ts >= v_min_ts
   and gpss_ts <= v_max_ts
;

GET DIAGNOSTICS v_cdc_row_cnt = ROW_COUNT;

--INSERT INTO public.cdc_log (target_tb, start_ts, end_ts, stag_rows, ins_cnt, del_cnt, up_cnt)
--VALUES (v_target_tb, v_start_ts, v_end_ts, v_cdc_row_cnt, v_ins_cnt, v_del_cnt, v_up_cnt);

v_result    := 'Start: '||to_char(v_start_ts, 'yyyy-mm-dd hh24:mi:ss')||', '||
                 'End: '||to_char(v_end_ts,   'yyyy-mm-dd hh24:mi:ss') ||', '||
                'Rows: '||trim(to_char(v_cdc_row_cnt, '999,999,999,999'))||', '||
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
echo "==========================================================================================="
echo "Source File :"
ls -l $OUT_FILE
echo "-------------------------------------------------------------------------------------------"
echo "Please review and execute :"
echo "psql -d $DBNAME -f "$OUT_FILE
echo "==========================================================================================="
echo
