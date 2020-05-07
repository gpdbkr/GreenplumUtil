--truncate table public.template_src_stg;

insert into public.template_src_stg values (1, 'A2', NULL, NULL, now(), 'U');
insert into public.template_src_stg values (2, NULL, 'C2', NULL, now(), 'U');
insert into public.template_src_stg values (3, NULL, NULL, 'A2', now(), 'U');

insert into public.template_src_stg values (7, 'D2', NULL, NULL, now(), 'U');
insert into public.template_src_stg values (8, NULL, 'B2', NULL, now(), 'U');
insert into public.template_src_stg values (9, NULL, NULL, 'A2', now(), 'U');

insert into public.template_src_stg values (2, NULL, 'C2', NULL, now(), 'U');
insert into public.template_src_stg values (1, NULL, NULL, 'D2', now(), 'U');
insert into public.template_src_stg values (3, NULL, 'C2', NULL, now(), 'U');

insert into public.template_src_stg values (8, 'A2', NULL, NULL, now(), 'U');
insert into public.template_src_stg values (7, NULL, NULL, 'E2', now(), 'U');
insert into public.template_src_stg values (1, NULL, 'C2', NULL, now(), 'U');

insert into public.template_src_stg values (8, 'D2', NULL, NULL, now(), 'U');
insert into public.template_src_stg values (1, NULL, NULL, 'A2', now(), 'U');
insert into public.template_src_stg values (9, 'E2', NULL, NULL, now(), 'U');

insert into public.template_src_stg values (2, NULL, 'C2', NULL, now(), 'U');
insert into public.template_src_stg values (1, NULL, NULL, 'C2', now(), 'U');
insert into public.template_src_stg values (3, 'A2', NULL, NULL, now(), 'U');

insert into public.template_src_stg values (7, NULL, NULL, 'B2', now(), 'U');
insert into public.template_src_stg values (9, NULL, NULL, 'C2', now(), 'U');
insert into public.template_src_stg values (8, NULL, 'B2', NULL, now(), 'U');

select * from public.template_src_stg order by z_cdc_ts;
