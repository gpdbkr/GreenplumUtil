
insert into gpss_test.tb_demo_cud_src values (21, 'A', 'A', 'A', now());
update gpss_test.tb_demo_cud_src set c1 = 'B' where id = 21 ;
delete from gpss_test.tb_demo_cud_src where id = 21;

insert into gpss_test.tb_demo_cud_src values (21, 'C', 'C', 'C', now());
update gpss_test.tb_demo_cud_src set c2 = 'D' where id = 21 ;
update gpss_test.tb_demo_cud_src set c2 = 'E' where id = 21 ;

insert into gpss_test.tb_demo_cud_src values (22, 'A', 'A', 'A', now());
update gpss_test.tb_demo_cud_src set c1 = 'B' where id = 22 ;
update gpss_test.tb_demo_cud_src set c2 = 'C' where id = 22 ;
update gpss_test.tb_demo_cud_src set c1 = 'D' where id = 22 ;
update gpss_test.tb_demo_cud_src set c3 = 'B' where id = 22 ;
update gpss_test.tb_demo_cud_src set c1 = 'B1' where id = 22 ;

select * from gpss_test.tb_demo_cud_src order by 1,5;
