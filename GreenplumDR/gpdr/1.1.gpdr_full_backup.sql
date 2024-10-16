create table public.gpdr_test_heap (id int, type text ) distributed by (id);
create table public.gpdr_test_ao (id int, type text ) with (appendonly=true, compresstype=zstd, compresslevel=7)  distributed by (id);
create table public.gpdr_test_replicated (id int, type text ) with (appendonly=true, compresstype=zstd, compresslevel=7)  distributed by (id);

insert into public.gpdr_test_heap       select i, 'full_heap' from generate_series(1,100) i;
insert into public.gpdr_test_ao         select i, 'full_ao' from generate_series(1,100) i;
insert into public.gpdr_test_replicated select i, 'full_replicated' from generate_series(1,100) i;

