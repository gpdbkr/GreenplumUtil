insert into public.gpdr_test_heap       select i, 'cont_heap' from generate_series(201,300) i;
insert into public.gpdr_test_ao         select i, 'cont_ao' from generate_series(201,300) i;
insert into public.gpdr_test_replicated select i, 'cont_replicated' from generate_series(201,300) i;

create table public.gpdr_test_cont (id int, type text ) with (appendonly=true, compresstype=zstd, compresslevel=7)  distributed by (id);
insert into  public.gpdr_test_cont select i, 'cont_ddl_dml' from generate_series(201,300) i;

create view public.gpdr_view as select * from public.gpdr_test_heap;
