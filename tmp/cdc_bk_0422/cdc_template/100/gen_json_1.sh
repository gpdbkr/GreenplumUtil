psql pocdb << +

\a
\t
\c /home/gpadmin/pivotal/cdc/cdc_template_100/json_template.json

select '{ "id":   '|| i ||
       ', "c1": "v1-'|| i || '"' ||
	   ', "c2": "v1-'|| i || '"' ||
	   ', "c3": "v1-'|| i || '"' ||
	   ', "ts": "'||to_char(clock_timestamp(),'yyyy-mm-ddThh24:mi:ss.us')|| '"' ||
	   ', "cud_fg": "I" }'
from   generate_series(1,200000) i
;

select '{ "id":   '|| i ||
       ', "c1": "v2-'|| i || '"' ||
	   ', "c2": "v2-'|| i || '"' ||
	   ', "c3": "v2-'|| i || '"' ||
	   ', "ts": "'||to_char(clock_timestamp(),'yyyy-mm-ddThh24:mi:ss.us')|| '"' ||
	   ', "cud_fg": "U" }'
from   generate_series(20001,40000) i
;

select '{ "id":   '|| i ||
	   ', "ts": "'||to_char(clock_timestamp(),'yyyy-mm-ddThh24:mi:ss.us')|| '"' ||
	   ', "cud_fg": "D" }'
from   generate_series(60001,80000) i
;
+

cat /home/gpadmin/pivotal/cdc/cdc_template_100/json_template.json | grep I | wc -l
cat /home/gpadmin/pivotal/cdc/cdc_template_100/json_template.json | grep U | wc -l
cat /home/gpadmin/pivotal/cdc/cdc_template_100/json_template.json | grep D | wc -l
