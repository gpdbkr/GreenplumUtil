--trucate gpss_test.tb_demo_cud_src;

insert into gpss_test.tb_demo_cud_src values (7, 'A', 'A', 'A', now());
insert into gpss_test.tb_demo_cud_src values (8, 'A', 'A', 'A', now());
insert into gpss_test.tb_demo_cud_src values (9, 'A', 'A', 'A', now());

delete from gpss_test.tb_demo_cud_src where id = 3;
update gpss_test.tb_demo_cud_src set c1 = 'B', c2 = 'B', c3 = 'B' where id = 8 ;
delete from gpss_test.tb_demo_cud_src where id = 2;

delete from gpss_test.tb_demo_cud_src where id = 4;
update gpss_test.tb_demo_cud_src set c1 = 'B1', c2 = 'B1', c3 = 'B1' where id = 5 ;
update gpss_test.tb_demo_cud_src set c1 = 'B', c2 = 'B', c3 = 'B' where id = 7 ;

insert into gpss_test.tb_demo_cud_src values (10, 'A', 'A', 'A', now());
delete from gpss_test.tb_demo_cud_src where id = 3;
update gpss_test.tb_demo_cud_src set c1 = 'C1', c2 = 'C1', c3 = 'C1' where id =5 ;

delete from gpss_test.tb_demo_cud_src where id = 7;
insert into gpss_test.tb_demo_cud_src values (7, 'B1', 'B1', 'B1', now());
delete from gpss_test.tb_demo_cud_src where id = 8;

insert into gpss_test.tb_demo_cud_src values (2, 'D', 'D', 'D', now());
insert into gpss_test.tb_demo_cud_src values (8, 'C', 'C', 'C', now());
update gpss_test.tb_demo_cud_src set c1 = 'D', c2 = 'D', c3 = 'D' where id = 2 ;

update gpss_test.tb_demo_cud_src set c1 = 'D', c2 = 'D', c3 = 'D' where id = 5 ;
insert into gpss_test.tb_demo_cud_src values (3, 'C', 'C', 'C', now());

select * from gpss_test.tb_demo_cud_src order by 1;
