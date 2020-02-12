select 'analyze '||schemaname||'.'||tablename ||';' qry
from   pg_tables
where  schemaname = 'bda01'
