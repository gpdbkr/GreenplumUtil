psql -e << +

--select 'gpss_stg.tmp_tpch_customer' tb_nm, count(*) from gpss_stg.tmp_tpch_customer;
--select 'tpch.customer' tb_nm, count(*) from tpch.customer;
select * from gpss.gpss_udf_exec_log order by start_ts;
select 'tpch.customer' tb_nm, count(*) from tpch.customer;
select c_comment, count(*) From tpch.customer group by 1 order by 1;
--select * from tpch.customer order by 1;
+
