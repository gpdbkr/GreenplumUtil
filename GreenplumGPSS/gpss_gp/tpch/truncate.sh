psql -e << +

delete from gpss_stg.tmp_tpch_customer;
truncate table  gpss_stg.stg_tpch_customer;
truncate table  tpch.customer;
truncate table  gpss.gpss_udf_exec_log;

select * from gpss.gpss_udf_exec_log order by 1;
+
