truncate table public.template_src;

insert into public.template_src values (1, 'A', 'A', 'A', now());
insert into public.template_src values (2, 'A', 'A', 'A', now());
insert into public.template_src values (3, 'A', 'A', 'A', now());

update public.template_src set c1 = 'B', c2 = 'B', c3 = 'B' where id =1 ;
update public.template_src set c1 = 'B', c2 = 'B', c3 = 'B' where id =2 ;
update public.template_src set c1 = 'B', c2 = 'B', c3 = 'B' where id =3 ;

delete from public.template_src where id = 1;
insert into public.template_src values (1, 'A1', 'A1', 'A1', now());
update public.template_src set c1 = 'C', c2 = 'C', c3 = 'C' where id =2 ;

insert into public.template_src values (4, 'A', 'A', 'A', now());
delete from public.template_src where id = 4;
insert into public.template_src values (4, 'A1', 'A1', 'A1', now());
delete from public.template_src where id = 4;

insert into public.template_src values (5, 'A', 'A', 'A', now());
delete from public.template_src where id = 5;
insert into public.template_src values (5, 'A1', 'A1', 'A1', now());

insert into public.template_src values (6, 'A', 'A', 'A', now());
update public.template_src set c1 = 'B', c2 = 'B', c3 = 'B' where id =6 ;
update public.template_src set c1 = 'C', c2 = 'C', c3 = 'C' where id =6 ;
update public.template_src set c1 = 'D', c2 = 'D', c3 = 'D' where id =6 ;

select * from public.template_src order by 1;
