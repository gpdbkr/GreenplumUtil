psql -AXt<< +
select 	'truncate table '||schemaname||'.'||tablename ||';'
from 	pg_catalog.pg_tables
where 	schemaname = 'rptadm'
and 	tablename not like 'gpka%';
+