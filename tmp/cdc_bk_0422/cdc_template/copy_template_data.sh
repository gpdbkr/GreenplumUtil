for i in `seq 1 5`
do
echo $i

psql -ec "truncate table public.template_stg;" pocdb
psql -ef gen_template_stg_$i.sql pocdb
psql <<~
copy (
select '{ "id":  '||coalesce (id::text, 'NULL') ||
                ', "c1": "'||coalesce (c1::text, 'NULL')||'"'||
	            ', "c2": "'||coalesce (c2::text, 'NULL')||'"'||
	            ', "c3": "'||coalesce (c3::text, 'NULL')||'"'||
	            ', "ts": "'||coalesce (ts::text, 'NULL')||'"'||
	            ', "cud_fg": "'||coalesce (cud_fg::text, 'NULL')||'" }'
FROM public.template_stg
ORDER BY ts
) to '/home/gpadmin/pivotal/cdc/cdc_template/json_template_stg_$i.json'
!
done
	   