-- truncate table gpss_test.tb_demo_cud_src;

update gpss_test.tb_demo_cud_src set c1 = 'A2' where id = 1;
update gpss_test.tb_demo_cud_src set c2 = 'C2' where id = 2 ;
update gpss_test.tb_demo_cud_src set c3 = 'A2' where id = 3 ;

update gpss_test.tb_demo_cud_src set c1 = 'D2' where id = 7 ;
update gpss_test.tb_demo_cud_src set c2 = 'B2' where id = 8 ;
update gpss_test.tb_demo_cud_src set c3 = 'A2' where id = 9 ;

update gpss_test.tb_demo_cud_src set c2 = 'C2' where id = 2 ;
update gpss_test.tb_demo_cud_src set c3 = 'D2' where id = 1 ;
update gpss_test.tb_demo_cud_src set c2 = 'C2' where id = 3 ;

update gpss_test.tb_demo_cud_src set c1 = 'A2' where id = 8 ;
update gpss_test.tb_demo_cud_src set c3 = 'E2' where id = 7 ;
update gpss_test.tb_demo_cud_src set c2 = 'C2' where id = 1 ;

update gpss_test.tb_demo_cud_src set c1 = 'D2' where id = 8 ;
update gpss_test.tb_demo_cud_src set c3 = 'A2' where id = 1 ;
update gpss_test.tb_demo_cud_src set c1 = 'E2' where id = 9 ;

update gpss_test.tb_demo_cud_src set c2 = 'C2' where id = 2 ;
update gpss_test.tb_demo_cud_src set c3 = 'C2' where id = 1 ;
update gpss_test.tb_demo_cud_src set c1 = 'A2' where id = 3 ;

update gpss_test.tb_demo_cud_src set c3 = 'B2' where id = 7 ;
update gpss_test.tb_demo_cud_src set c3 = 'C2' where id = 9 ;
update gpss_test.tb_demo_cud_src set c2 = 'B2' where id = 8 ;

SELECT * FROM gpss_test.tb_demo_cud_src ORDER BY 1,5;
