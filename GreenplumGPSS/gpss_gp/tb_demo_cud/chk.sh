psql -e << +

select 'gpss_test.tb_demo_cud_stg' tb_nm, count(*) from gpss_test.tb_demo_cud_stg;
select 'gpss_test.tb_demo_cud_target' tb_nm, count(*) from gpss_test.tb_demo_cud_target;

select * From gpss_test.tb_demo_cud_target order by id;
+
