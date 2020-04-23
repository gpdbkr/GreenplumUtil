delete from gpss_test.tb_demo_cud_src where id = 8;
update gpss_test.tb_demo_cud_src set c1 = 'B', c2 = 'B', c3 = 'B' where id = 9 ;
insert into gpss_test.tb_demo_cud_src values (8, 'D', 'D', 'D', now());

delete from gpss_test.tb_demo_cud_src where id = 1;
delete from gpss_test.tb_demo_cud_src where id = 5;
delete from gpss_test.tb_demo_cud_src where id = 7;

insert into gpss_test.tb_demo_cud_src values (11, 'A', 'A', 'A', now());
insert into gpss_test.tb_demo_cud_src values (12, 'E', 'E', 'E', now());
delete from gpss_test.tb_demo_cud_src where id = 6;

update gpss_test.tb_demo_cud_src set c1 = 'F', c2 = 'F', c3 = 'F' where id = 6 ;
insert into gpss_test.tb_demo_cud_src values (14, 'A', 'A', 'A', now());
insert into gpss_test.tb_demo_cud_src values (1, 'B', 'B', 'B', now());

insert into gpss_test.tb_demo_cud_src values (13, 'A', 'A', 'A', now());
insert into gpss_test.tb_demo_cud_src values (7, 'C', 'C', 'C', now());
delete from gpss_test.tb_demo_cud_src where id = 12;

delete from gpss_test.tb_demo_cud_src where id = 11;
update gpss_test.tb_demo_cud_src set c1 = 'B', c2 = 'B', c3 = 'B' where id = 3 ;
update gpss_test.tb_demo_cud_src set c1 = 'C', c2 = 'C', c3 = 'C' where id = 3 ;

insert into gpss_test.tb_demo_cud_src values (11, 'B', 'B', 'B', now());
update gpss_test.tb_demo_cud_src set c1 = 'E', c2 = 'E', c3 = 'E' where id = 2 ;

select * from gpss_test.tb_demo_cud_src order by 1,5;
