select type, count(*) cnt from public.gpdr_test_heap       group by type order by type;
select type, count(*) cnt from public.gpdr_test_ao         group by type order by type;
select type, count(*) cnt from public.gpdr_test_replicated group by type order by type;
select type, count(*) cnt from public.gpdr_test_incr       group by type order by type;

select public.gpdr_plpy3_bool(-1);
