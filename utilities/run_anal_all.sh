psql -AXtc "
select  'analyze '||schema_nm||'.'|| tb_nm||'(' ||dk_col_nm ||');' an
from     dba.v_tb_dk_info a
where  schema_nm not in ('gp_toolkit','public')
and    (    tb_nm not like '%1_prt_p%'
         or (   split_part(tb_nm, '_1_prt_', 2) <> 'prior' 
                and split_part(tb_nm, '_1_prt_', 2) >= 'p201209' 
            )
         
       )
--and    tb_nm <= 'zzzz'
order by 1; 
"   | psql -e

CREATE OR REPLACE VIEW dba.tb_dk_info AS 
 WITH tb_col_info AS (
         SELECT z.schema_nm, z.tb_nm, z.col_nm, z.col_ord, z.attnum, z.dk_arry[z.col_ord] AS dk_col_attnum
           FROM ( SELECT n.nspname AS schema_nm, c.relname AS tb_nm, a.attname AS col_nm, row_number() OVER(
                 PARTITION BY n.nspname, c.relname
                  ORDER BY a.attnum) AS col_ord, a.attnum, con.conkey AS pk_arry, d.attrnums AS dk_arry
                   FROM pg_class c
              JOIN pg_namespace n ON c.relnamespace = n.oid
         JOIN pg_attribute a ON c.oid = a.attrelid AND a.attnum >= 0
    JOIN pg_type t ON a.atttypid = t.oid
   LEFT JOIN pg_partition_rule pr ON c.oid = pr.parchildrelid
   LEFT JOIN gp_distribution_policy d ON c.oid = d.localoid AND (a.attnum = ANY (d.attrnums))
   LEFT JOIN pg_constraint con ON c.oid = con.conrelid
  WHERE c.relkind = 'r'::"char" AND pr.parchildrelid IS NULL AND (con.contype = 'p'::"char" OR con.contype IS NULL)) z
        )
 SELECT m.schema_nm, m.tb_nm, array_to_string((array_agg(m.col_nm
  ORDER BY m.dk_col_attnum))[1:100], ','::text) AS dk_col_nm
   FROM tb_col_info m
   LEFT JOIN tb_col_info dk ON m.schema_nm = dk.schema_nm AND m.tb_nm = dk.tb_nm AND m.attnum = dk.dk_col_attnum
  WHERE dk.dk_col_attnum IS NOT NULL
  GROUP BY m.schema_nm, m.tb_nm;
