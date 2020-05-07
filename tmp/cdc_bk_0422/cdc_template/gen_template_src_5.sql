-- truncate table public.template_src;

update public.template_src set c1 = 'A2' where id = 1;
update public.template_src set c2 = 'C2' where id = 2 ;
update public.template_src set c3 = 'A2' where id = 3 ;

update public.template_src set c1 = 'D2' where id = 7 ;
update public.template_src set c2 = 'B2' where id = 8 ;
update public.template_src set c3 = 'A2' where id = 9 ;

update public.template_src set c2 = 'C2' where id = 2 ;
update public.template_src set c3 = 'D2' where id = 1 ;
update public.template_src set c2 = 'C2' where id = 3 ;

update public.template_src set c1 = 'A2' where id = 8 ;
update public.template_src set c3 = 'E2' where id = 7 ;
update public.template_src set c2 = 'C2' where id = 1 ;

update public.template_src set c1 = 'D2' where id = 8 ;
update public.template_src set c3 = 'A2' where id = 1 ;
update public.template_src set c1 = 'E2' where id = 9 ;

update public.template_src set c2 = 'C2' where id = 2 ;
update public.template_src set c3 = 'C2' where id = 1 ;
update public.template_src set c1 = 'A2' where id = 3 ;

update public.template_src set c3 = 'B2' where id = 7 ;
update public.template_src set c3 = 'C2' where id = 9 ;
update public.template_src set c2 = 'B2' where id = 8 ;

SELECT * FROM public.template_src ORDER BY 1,5;
