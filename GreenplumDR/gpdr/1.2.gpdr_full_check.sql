select type, count(*) cnt from public.gpdr_test_heap       group by type order by type;
select type, count(*) cnt from public.gpdr_test_ao         group by type order by type;
select type, count(*) cnt from public.gpdr_test_replicated group by type order by type;

