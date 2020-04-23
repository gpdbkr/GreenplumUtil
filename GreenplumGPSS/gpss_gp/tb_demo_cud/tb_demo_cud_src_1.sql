truncate table gpss_test.tb_demo_cud_src;

insert into gpss_test.tb_demo_cud_src values (1, 'A', 'A', 'A', now());
insert into gpss_test.tb_demo_cud_src values (2, 'A', 'A', 'A', now());
insert into gpss_test.tb_demo_cud_src values (3, 'A', 'A', 'A', now());

update gpss_test.tb_demo_cud_src set c1 = 'B', c2 = 'B', c3 = 'B' where id =1 ;
update gpss_test.tb_demo_cud_src set c1 = 'B', c2 = 'B', c3 = 'B' where id =2 ;
update gpss_test.tb_demo_cud_src set c1 = 'B', c2 = 'B', c3 = 'B' where id =3 ;

delete from gpss_test.tb_demo_cud_src where id = 1;
insert into gpss_test.tb_demo_cud_src values (1, 'A1', 'A1', 'A1', now());
update gpss_test.tb_demo_cud_src set c1 = 'C', c2 = 'C', c3 = 'C' where id =2 ;

insert into gpss_test.tb_demo_cud_src values (4, 'A', 'A', 'A', now());
delete from gpss_test.tb_demo_cud_src where id = 4;
insert into gpss_test.tb_demo_cud_src values (4, 'A1', 'A1', 'A1', now());
delete from gpss_test.tb_demo_cud_src where id = 4;

insert into gpss_test.tb_demo_cud_src values (5, 'A', 'A', 'A', now());
delete from gpss_test.tb_demo_cud_src where id = 5;
insert into gpss_test.tb_demo_cud_src values (5, 'A1', 'A1', 'A1', now());

insert into gpss_test.tb_demo_cud_src values (6, 'A', 'A', 'A', now());
update gpss_test.tb_demo_cud_src set c1 = 'B', c2 = 'B', c3 = 'B' where id =6 ;
update gpss_test.tb_demo_cud_src set c1 = 'C', c2 = 'C', c3 = 'C' where id =6 ;
update gpss_test.tb_demo_cud_src set c1 = 'D', c2 = 'D', c3 = 'D' where id =6 ;

select * from gpss_test.tb_demo_cud_src order by 1;
