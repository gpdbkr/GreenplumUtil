--truncate table public.template_stg;

insert into public.template_stg values (8, NULL, NULL, NULL, now(), 'D');
insert into public.template_stg values (9, 'B', 'B', 'B', now(), 'U');
insert into public.template_stg values (8, 'D', 'D', 'D', now(), 'I');

insert into public.template_stg values (1, NULL, NULL, NULL, now(), 'D');
insert into public.template_stg values (5, NULL, NULL, NULL, now(), 'D');
insert into public.template_stg values (7, NULL, NULL, NULL, now(), 'D');

insert into public.template_stg values (11, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (12, 'E', 'E', 'E', now(), 'I');
insert into public.template_stg values (6, NULL, NULL, NULL, now(), 'D');

insert into public.template_stg values (6, 'F', 'F', 'F', now(), 'U');
insert into public.template_stg values (14, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (1, 'B', 'B', 'B', now(), 'I');

insert into public.template_stg values (13, 'A', 'A', 'A', now(), 'I');
insert into public.template_stg values (7, 'C', 'C', 'C', now(), 'I');
insert into public.template_stg values (12, NULL, NULL, NULL, now(), 'D');

insert into public.template_stg values (11, NULL, NULL, NULL, now(), 'D');
insert into public.template_stg values (3, 'B', 'B', 'B', now(), 'U');
insert into public.template_stg values (3, 'C', 'C', 'C', now(), 'U');

insert into public.template_stg values (11, 'B', 'B', 'B', now(), 'I');
insert into public.template_stg values (2, 'E', 'E', 'E', now(), 'U');

SELECT * from public.template_stg order by ts;
