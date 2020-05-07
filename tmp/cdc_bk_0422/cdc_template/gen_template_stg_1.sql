truncate table public.template_stg;

insert into public.template_stg values (1, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (2, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (3, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (1, 'B', 'B', 'B', now(), 'U');
insert into public.template_stg values (2, 'B', 'B', 'B', now(), 'U');
insert into public.template_stg values (3, 'B', 'B', 'B', now(), 'U');
insert into public.template_stg values (1, NULL, NULL, NULL, now(), 'D');
insert into public.template_stg values (1, 'A1', 'A1', 'A1', now(), 'I');
insert into public.template_stg values (2, 'C', 'C', 'C', now(), 'U');

insert into public.template_stg values (4, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (4, NULL, NULL, NULL, now(), 'D');
insert into public.template_stg values (4, 'A1', 'A1', 'A1', now(), 'I');
insert into public.template_stg values (4, NULL, NULL, NULL, now(), 'D');

insert into public.template_stg values (5, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (5, NULL, NULL, NULL, now(), 'D');
insert into public.template_stg values (5, 'A1', 'A1', 'A1', now(), 'I');

insert into public.template_stg values (6, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (6, 'B', 'B', 'B', now(), 'U');
insert into public.template_stg values (6, 'C', 'C', 'C', now(), 'U');
insert into public.template_stg values (6, 'D', 'D', 'D', now(), 'U');

SELECT * from public.template_stg order by ts;
