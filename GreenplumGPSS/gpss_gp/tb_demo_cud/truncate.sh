psql -e << +

truncate table gpss_test.tb_demo_cud_src;
truncate table gpss_test.tb_demo_cud_target;
--truncate table gpss_test.tb_demo_cud_stg;
delete from gpss_test.tb_demo_cud_stg;
vacuum gpss_test.tb_demo_cud_stg;

select 'gpss_test.tb_demo_cud_src' tb_nm, count(*) from gpss_test.tb_demo_cud_src;
select 'gpss_test.tb_demo_cud_stg' tb_nm, count(*) from gpss_test.tb_demo_cud_stg;
select 'gpss_test.tb_demo_cud_target' tb_nm, count(*) from gpss_test.tb_demo_cud_target;
+
