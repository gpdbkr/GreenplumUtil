rm -f /usr/local/gpdr/configs/pgbackrest*.conf
psql <<EOF
drop table if exists public.gpdr_test_heap;
drop table if exists public.gpdr_test_ao;
drop table if exists public.gpdr_test_replicated;
drop table if exists public.gpdr_test_incr;
drop table if exists public.gpdr_test_cont;

drop view if exists public.gpdr_view;

drop extension plpython3u cascade;
drop function if exists public.gpdr_plpy3_bool(a int);
EOF

echo 
echo "If you have previously set the environment, you must delete the backup setting path of minio."
echo "In the current setting, you need to delete the /gpdr/data subdirectory of minio."
