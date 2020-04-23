psql -e << +

create schema gpss;
create schema gpss_stg;
create schema gpss_tmp;

drop table if exists  gpss.gpss_udf_exec_log;
create table gpss.gpss_udf_exec_log
(
    target_tb varchar(63),
    start_ts  timestamp,
    end_ts	  timestamp,
    stg_tot_cnt   int,
    stg_ins_cnt   int,
    stg_del_cnt   int,
    stg_up_cnt    int,
    tgt_ins_cnt   int,
    tgt_del_cnt   int,
    tgt_up_cnt    int
)
distributed randomly;

CREATE OR REPLACE FUNCTION gpss.jsonb2_get_text(v_val jsonb, v_key text)
RETURNS text AS
$BODY$
DECLARE

		v_tmp	 		text;
		v_err_msg		text;
BEGIN
		v_tmp := v_val->v_key::text;

		if v_tmp = 'null' then
		   return null;
		else
		   return substr(v_tmp, 2, length(v_tmp)-2);
		end if;

EXCEPTION
WHEN others THEN
       v_err_msg := sqlerrm;
	   RAISE NOTICE 'ERROR_MSG : %' , v_err_msg;
return sqlerrm;

END;
$BODY$
LANGUAGE 'plpgsql' immutable;



CREATE OR REPLACE FUNCTION gpss.jsonb2_get_num(v_val jsonb, v_key text)
RETURNS numeric AS
$BODY$
DECLARE
		v_tmp	 		text;
		v_err_msg		text;
BEGIN

		v_tmp := v_val->v_key::text;

		if v_tmp = 'null' or replace(v_tmp, '"','') = '' then
		   return null;
		else
		   return (replace(v_tmp, '"',''))::numeric;
		end if;

EXCEPTION
WHEN others THEN
     return null;

END;
$BODY$
LANGUAGE 'plpgsql' immutable;


CREATE OR REPLACE FUNCTION gpss.jsonb2_get_ts(v_val jsonb, v_key text)
RETURNS timestamp AS
$BODY$
DECLARE

		v_tmp	 		text;
		v_err_msg		text;
BEGIN
		v_tmp := v_val->v_key::text;

		if v_tmp = 'null' then
		   return null;
		else
		   return to_timestamp(replace(substr(v_tmp, 2, length(v_tmp)-2), '"', ''),'yyyy-mm-dd hh24:mi:ss.us')::timestamp;
		end if;

EXCEPTION
WHEN others THEN
     return null;

END;
$BODY$
LANGUAGE 'plpgsql' immutable;


CREATE OR REPLACE FUNCTION gpss.jsonb2_get_text_meta(v_val text, v_c1 text, v2 text)
RETURNS numeric AS
$BODY$
DECLARE

		v_tmp	 		text;
		v_err_msg		text;
BEGIN
		v_tmp := ((substr(v_val, 2, length(v_val)-2)::json)-v_c1->v_c2)::text;


	    if v_tmp = 'null' then
		   return null;
		else
		   return substr(v_tmp, 2, length(v_tmp)-2);
		end if;

EXCEPTION
WHEN others THEN
       v_err_msg := sqlerrm;
	   RAISE NOTICE 'ERROR_MSG : %' , v_err_msg;
return sqlerrm;

END;
$BODY$
LANGUAGE 'plpgsql' immutable;



CREATE OR REPLACE FUNCTION gpss.jsonb2_get_ts_meta(v_val text, v_c1 text, v2 text)
RETURNS numeric AS
$BODY$
DECLARE

		v_tmp	 		text;
		v_err_msg		text;
BEGIN
		v_tmp := ((substr(v_val, 2, length(v_val)-2)::json)-v_c1->v_c2)::text;

	    if v_tmp = 'null' then
		   return null;
		else
		   return to_timestamp(replace(substr(v_tmp, 2, length(v_tmp)-2), '"', ''),'yyyy-mm-dd hh24:mi:ss.us')::timestamp;
		end if;

EXCEPTION
WHEN others THEN
       return null;

END;
$BODY$
LANGUAGE 'plpgsql' immutable;


CREATE OR REPLACE FUNCTION gpss.jsonb2_get_num_meta(v_val text, v_c1 text, v2 text)
RETURNS numeric AS
$BODY$
DECLARE

		v_tmp	 		text;
		v_err_msg		text;
BEGIN
		v_tmp := ((substr(v_val, 2, length(v_val)-2)::json)-v_c1->v_c2)::text;


	    if v_tmp = 'null' then
		   return null;
		else
		   return (replace(v_tmp, '"', ''))::numeric;
		end if;

EXCEPTION
WHEN others THEN
     return null;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE;

+
