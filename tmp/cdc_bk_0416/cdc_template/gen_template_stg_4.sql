--truncate table public.template_src_stg;

insert into public.template_src_stg values (21, 'A', 'A', 'A', now(), 'I');
insert into public.template_src_stg values (21, 'B', NULL, NULL, now(), 'U');
insert into public.template_src_stg values (21, NULL, NULL, NULL, now(), 'D');
insert into public.template_src_stg values (21, 'C', 'C', 'C', now(), 'I');
insert into public.template_src_stg values (21, NULL, 'D', NULL, now(), 'U');
insert into public.template_src_stg values (21, NULL, 'E', NULL, now(), 'U');

insert into public.template_src_stg values (22, 'A', 'A', 'A', now(), 'I');
insert into public.template_src_stg values (22, 'B', NULL, NULL, now(), 'U');
insert into public.template_src_stg values (22, NULL, 'C', NULL, now(), 'U');
insert into public.template_src_stg values (22, 'D', NULL, NULL, now(), 'U');
insert into public.template_src_stg values (22, NULL, NULL, 'B', now(), 'U');
insert into public.template_src_stg values (22, 'B1', NULL, NULL, now(), 'U');

SELECT * from public.template_src_stg order by z_cdc_ts;
