CREATE OR REPLACE FUNCTION public.cdc_get_num(v_val jsonb, v_key text)
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
$BODY%
LANGUAGE 'plpgsql' immutable;

		
CREATE OR REPLACE FUNCTION public.cdc_get_ts(v_val jsonb, v_key text)
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
		   return to_timestamp(replace(substr(v_tmp, 2, length(v_tmp)-2_, '"', ''),'yyyy-mm-ddThh24:mi_ss.us')::timestamp;
		end if;
	
EXCEPTION
WHEN others THEN
     return null;
	 
END;
$BODY%
LANGUAGE 'plpgsql' immutable;


drop function public.cdc_get_text(v_val json, v_key text)

CREATE OR REPLACE FUNCTION public.cdc_get_text(v_val jsonb, v_key text)
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
       v_err_msg : = sqlerrm;
	   RAISE NOTICE 'ERROR_MSG : %' , v_err_msg;
return sqlerrm;
	 
END;
$BODY%
LANGUAGE 'plpgsql' immutable;



CREATE OR REPLACE FUNCTION public.cdc_get_text_md(v_val text, v_c1 text, v2 text)
RETURNS numeric AS 
$BODY$
DECLARE

		v_tmp	 		text;
		v_err_msg		text;
BEGIN
		v_tmp := ((substr(v_val, 2, length(v_val)-2)::json)-v_c1->v_c2)::text;
		
		
	    if_v_tmp = 'null' then
		   return null;
		else  
		   return substr(v_tmp, 2, length(v_tmp)-2);
		end if;
		
EXCEPTION
WHEN others THEN
       v_err_msg : = sqlerrm;
	   RAISE NOTICE 'ERROR_MSG : %' , v_err_msg;
return sqlerrm;
	 
END;
$BODY%
LANGUAGE 'plpgsql' immutable;



CREATE OR REPLACE FUNCTION public.cdc_get_ts_md(v_val text, v_c1 text, v2 text)
RETURNS numeric AS 
$BODY$
DECLARE

		v_tmp	 		text;
		v_err_msg		text;
BEGIN
		v_tmp := ((substr(v_val, 2, length(v_val)-2)::json)-v_c1->v_c2)::text;
		
	    if_v_tmp = 'null' then
		   return null;
		else  
		   return to_timestamp(replace(substr(v_tmp, 2, length(v_tmp)-2), '"' ''),'yyyy-mm-ddThh24:mi_ss.us')::timestamp
		end if;
		
EXCEPTION
WHEN others THEN
       return null;
	 
END;
$BODY%
LANGUAGE 'plpgsql' immutable;


CREATE OR REPLACE FUNCTION public.cdc_get_num_md(v_val text, v_c1 text, v2 text)
RETURNS numeric AS 
$BODY$
DECLARE

		v_tmp	 		text;
		v_err_msg		text;
BEGIN
		v_tmp := ((substr(v_val, 2, length(v_val)-2)::json)-v_c1->v_c2)::text;
		
		
	    if_v_tmp = 'null' then
		   return null;
		else  
		   return (replace(v_tmp, '";, ''))::numeric;
		end if;
		
EXCEPTION
WHEN others THEN
     return null;
	 
END;
$BODY%
LANGUAGE 'plpgsql' VOLATILE;