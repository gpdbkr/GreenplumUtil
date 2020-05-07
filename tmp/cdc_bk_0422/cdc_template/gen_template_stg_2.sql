--truncate table public.template_stg;
insert into public.template_stg values (7, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (8, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (9, 'A', 'A', 'A', now(), 'I');

insert into public.template_stg values (3, NULL, NULL, NULL, now(), 'D');
insert into public.template_stg values (8, 'B', 'B', 'B', now(), 'U');
insert into public.template_stg values (2, NULL, NULL, NULL, now(), 'D');

insert into public.template_stg values (4, NULL, NULL, NULL, now(), 'D');
insert into public.template_stg values (5, 'B1', 'B1', 'B1', now(), 'U');
insert into public.template_stg values (7, 'B', 'B', 'B', now(), 'U');

insert into public.template_stg values (10, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (3, NULL, NULL, NULL, now(), 'D');
insert into public.template_stg values (5, 'C1', 'C1', 'C1', now(), 'U');

insert into public.template_stg values (7, NULL, NULL, NULL, now(), 'D');
insert into public.template_stg values (7, 'B1', 'B1', 'B1', now(), 'I');
insert into public.template_stg values (8, NULL, NULL, NULL, now(), 'D');

insert into public.template_stg values (2, 'D', 'D', 'D', now(), 'I');
insert into public.template_stg values (8, 'C', 'C', 'C', now(), 'I');
insert into public.template_stg values (2, 'D', 'D', 'D', now(), 'U');

insert into public.template_stg values (5, 'D', 'D', 'D', now(), 'U');
insert into public.template_stg values (3, 'C', 'C', 'C', now(), 'I');

SELECT * from public.template_stg order by ts;
