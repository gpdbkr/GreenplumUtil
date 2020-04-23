for i in `seq 1 5`
do 
echo ">>>>>>>>>>>>>>>>>>>>>>>: " $i

psql -ec "delete from  gpss_test.tb_demo_cud_stg;"
psql -ef tb_demo_cud_stg_$i.sql 

FILENAME=$PWD/json_tb_demo_cud_stg_$i.json
echo $FILENAME

psql << +

copy (
SELECT replace('{ "id": '||id||', "c1": "'||coalesce(c1, 'null')
                    ||'", "c2": "'||coalesce(c2, 'null')
                    ||'", "c3": "'||coalesce(c3, 'null')
                    ||'", "gpss_ts": "'||gpss_ts
                    ||'", "gpss_fg": "'||gpss_fg||'" }', '"null"', 'null') qry
                    
FROM gpss_test.tb_demo_cud_stg 
order by gpss_ts
) 
to '${FILENAME}';
+

done
