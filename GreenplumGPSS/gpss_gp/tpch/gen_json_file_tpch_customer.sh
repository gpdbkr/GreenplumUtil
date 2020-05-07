FILENAME=$PWD/tpch.customer.json
echo $FILENAME

psql -d edu << +
copy (
select 
	   case 
	       when b.i = 1 then 
			   '{ "metadata": {"gpss_fg":"'||b.gpss_fg||'",  "gpss_ts":"'||now() + (trim(to_char(c_custkey* 10 + b.i, '9999999'))||'us')::interval||'" }, '||
			   '  "data":{'||
			              '"c_custkey": "'||c_custkey||'", '||
		              	  '"c_name": "'||c_name||'", '||
		              	  '"c_address": "'||c_address||'", '||
		            	  '"c_nationkey": "'||c_nationkey||'", '||
		             	  '"c_phone": "'||c_phone||'", '||
		            	  '"c_acctbal": "'||c_acctbal||'", '||
		            	  '"c_mktsegment": "'||c_mktsegment||'", '||
		              	  '"c_comment": "op#1"} '||
		        ' } '   
           --update #1
	       when b.i = 2 then 
			   '{ "metadata": {"gpss_fg":"'||b.gpss_fg||'",  "gpss_ts":"'||now() + (trim(to_char(c_custkey* 10 + b.i, '9999999'))||'us')::interval||'" }, '||
			   '  "data":{'||
			              '"c_custkey": "'||c_custkey||'", '||
		              	  '"c_comment": "op#2"} '||
		        ' } '   
           --delete
	       when b.i = 3 then 
			   '{ "metadata": {"gpss_fg":"'||b.gpss_fg||'",  "gpss_ts":"'||now() + (trim(to_char(c_custkey* 10 + b.i, '9999999'))||'us')::interval||'" }, '||
			   '  "data":{'||
			              '"c_custkey": "'||c_custkey||'", '||
		              	  '"c_comment": "op#3"} '||
		        ' } '   

		   when b.i = 4 then 
			   '{ "metadata": {"gpss_fg":"'||b.gpss_fg||'",  "gpss_ts":"'||now() + (trim(to_char(c_custkey* 10 + b.i, '9999999'))||'us')::interval||'" }, '||
			   '  "data":{'||
			              '"c_custkey": "'||c_custkey||'", '||
		              	  '"c_name": "'||c_name||'", '||
		              	  '"c_address": "'||c_address||'", '||
		            	  '"c_nationkey": "'||c_nationkey||'", '||
		             	  '"c_phone": "'||c_phone||'", '||
		            	  '"c_acctbal": "'||c_acctbal||'", '||
		            	  '"c_mktsegment": "'||c_mktsegment||'", '||
		              	  '"c_comment": "op#4"} '||
		        ' } '   

		   when b.i = 5 then 
			   '{ "metadata": {"gpss_fg":"'||b.gpss_fg||'",  "gpss_ts":"'||now() + (trim(to_char(c_custkey* 10 + b.i, '9999999'))||'us')::interval||'" }, '||
			   '  "data":{'||
                                      '"c_custkey": "'||c_custkey||'", '||
                                  '"c_name": "'||'update_name'||'", '||
                                  '"c_address": "'||'update_address'||'", '||
                                  '"c_nationkey": "'||'0'||'", '||
                                  '"c_phone": "'||'xx-xxx-xxx-xxxx'||'", '||
                                  '"c_acctbal": "'||'0.0'||'", '||
                                  '"c_mktsegment": "'||'update_seg'||'", '||
		              	  '"c_comment": "op#5"} '||
		        ' } '   
	       when b.i = 6 then 
			   '{ "metadata": {"gpss_fg":"'||b.gpss_fg||'",  "gpss_ts":"'||now() + (trim(to_char(c_custkey* 10 + b.i, '9999999'))||'us')::interval||'" }, '||
			   '  "data":{'||
			              '"c_custkey": "'||c_custkey||'", '||
		              	  '"c_name": "'||'updated name'||'", '||
		              	  '"c_comment": "op#6"} '||
		        ' } '   
	       when b.i = 7 then 
			   '{ "metadata": {"gpss_fg":"'||b.gpss_fg||'",  "gpss_ts":"'||now() + (trim(to_char(c_custkey* 10 + b.i, '9999999'))||'us')::interval||'" }, '||
			   '  "data":{'||
			              '"c_custkey": "'||c_custkey||'", '||
		              	  '"c_acctbal": "'||'-1.0'||'", '||
		              	  '"c_comment": "op#7"} '||
		        ' } '   
		              	  
		   end q             
FROM   edu_sch.customer a
       , edu_sch.t_copy b
where  (a.c_custkey%7 = 1 and b.i  = 1 )
or     (a.c_custkey%7 = 2 and b.i <= 2 )
or     (a.c_custkey%7 = 3 and b.i <= 3 )
or     (a.c_custkey%7 = 4 and b.i <= 4 )
or     (a.c_custkey%7 = 5 and b.i <= 5 )
or     (a.c_custkey%7 = 6 and b.i <= 6 )
or     (a.c_custkey%7 = 0 and b.i <= 7 )
order by c_custkey, b.i
)
to '${FILENAME}';
+

exit

psql << +
create table edu_sch.t_copy
(
 i int, 
 gpss_fg varchar(100)
)
distributed by (i);

insert into edu_sch.t_copy
values
(1, 'I'), (2, 'U'), (3, 'D'), (4, 'I'),(5, 'U');
+
