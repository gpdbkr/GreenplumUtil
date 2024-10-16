insert into public.gpdr_test_heap       select i, 'incr_heap' from generate_series(101,200) i;
insert into public.gpdr_test_ao         select i, 'incr_ao' from generate_series(101,200) i;
insert into public.gpdr_test_replicated select i, 'incr_replicated' from generate_series(101,200) i;

create table public.gpdr_test_incr (id int, type text ) with (appendonly=true, compresstype=zstd, compresslevel=7)  distributed by (id);
insert into  public.gpdr_test_incr select i, 'incr_ddl_dml' from generate_series(101,200) i;

CREATE EXTENSION plpython3u;
CREATE OR REPLACE FUNCTION public.gpdr_plpy3_bool(a int) RETURNS boolean AS $$
# container: plc_python3_shared
    if (a > 0):
        return True
    else:
        return False
$$ LANGUAGE plpython3u;

select public.gpdr_plpy3_bool(-1);
