drop view if exists dba.v_sys_201801;
drop external table dba.ext_sys_201801;

CREATE EXTERNAL WEB TABLE dba.ext_sys_201801
(   
  hostname text,
  t text
)
 EXECUTE E'cat /data/dba/utilities/statlog/sys.201801*.txt | grep bdpctmgp | grep "|"  | grep "-" ' ON MASTER 
 FORMAT 'text' (delimiter ']' null '')
ENCODING 'UTF8';

drop view if exists dba.v_sys_201801;

create or replace view dba.v_sys_201801
as
select hostname
	, tm
 	, trim(substr(cpu, 1, 3))::int cpu_usr
 	, trim(substr(cpu, 5, 3))::int cpu_sys
 	, trim(substr(cpu, 9, 3))::int cpu_idl
 	, trim(replace(substr(cpu, 13, 3), '-', 0))::int cpu_wait
	, round(substr(disk, 1, 4)::numeric * case 
		                        when substr(disk, 5,1) = 'B' then 1.0 
		                        when substr(disk, 5,1) = 'k' then 1024.0 
		                        when substr(disk, 5,1) = 'M' then 1024.0*1024 
		                        when substr(disk, 5,1) = 'G' then 1024.0*1024*1024 
		                        else 0.0
		                    end  / 1024.0/ 1024, 0) disk_r_mb
	, substr(disk, 1,5)  disk_r
	, round(substr(disk, 7, 4)::numeric * case 
		                        when substr(disk, 5,1)  = 'B' then 1.0 	
		                        when substr(disk, 11,1) = 'k' then 1024.0 
		                        when substr(disk, 11,1) = 'M' then 1024.0*1024 
		                        when substr(disk, 11,1) = 'G' then 1024.0*1024*1024 
		                        else 0.0
		                    end  / 1024.0/ 1024, 0) disk_w_mb
		                    		                    

	, substr(disk, 7, 5) disk_w

	, round(substr(net, 1, 4)::numeric * case 
		                        when substr(net, 5,1) = 'B' then 1.0 	
		                        when substr(net, 5,1) = 'k' then 1024.0 
		                        when substr(net, 5,1) = 'M' then 1024.0*1024 
		                        when substr(net, 5,1) = 'G' then 1024.0*1024*1024 
		                        else 0.0
		                    end  / 1024.0/ 1024, 0) net_r_mb
	, substr(net, 1,5)  net_r
	, round(substr(net, 7, 4)::numeric * case 
		                        when substr(net, 11,1) = 'B' then 1.0 	
		                        when substr(net, 11,1) = 'k' then 1024.0 
		                        when substr(net, 11,1) = 'M' then 1024.0*1024 
		                        when substr(net, 11,1) = 'G' then 1024.0*1024*1024 
		                        else 0.0
		                    end  / 1024.0/ 1024, 0) net_w_mb
		                    		                    

	, substr(net, 7, 5) net_w	

	, round(substr(mem, 1, 4)::numeric * case 
		                        when substr(mem, 5,1) = 'B' then 1.0 	
		                        when substr(mem, 5,1) = 'k' then 1024.0 
		                        when substr(mem, 5,1) = 'M' then 1024.0*1024 
		                        when substr(mem, 5,1) = 'G' then 1024.0*1024*1024 
		                        else 0.0
		                    end  /1024.0/1024/1024, 1) mem_used_gb
	, substr(mem, 1,5)  mem_used

	, round(substr(mem, 7, 4)::numeric * case 
		                        when substr(mem, 11,1) = 'B' then 1.0 	
		                        when substr(mem, 11,1) = 'k' then 1024.0 
		                        when substr(mem, 11,1) = 'M' then 1024.0*1024 
		                        when substr(mem, 11,1) = 'G' then 1024.0*1024*1024 
		                        else 0.0
		                    end  /1024.0/1024/1024, 1) mem_buff_gb
	, substr(mem, 7,5)  mem_buff

	, round(substr(mem, 13, 4)::numeric * case 
		                        when substr(mem, 17,1) = 'B' then 1.0 	
		                        when substr(mem, 17,1) = 'k' then 1024.0 
		                        when substr(mem, 17,1) = 'M' then 1024.0*1024 
		                        when substr(mem, 17,1) = 'G' then 1024.0*1024*1024 
		                        else 0.0
		                    end  /1024.0/1024/1024, 1) mem_cach_gb
	, substr(mem, 13,5)  mem_cach

	, round(substr(mem, 19, 4)::numeric * case 
		                        when substr(mem, 23,1) = 'B' then 1.0 	
		                        when substr(mem, 23,1) = 'k' then 1024.0 
		                        when substr(mem, 23,1) = 'M' then 1024.0*1024 
		                        when substr(mem, 23,1) = 'G' then 1024.0*1024*1024 
		                        else 0.0
		                    end  /1024.0/1024/1024, 1) mem_free_gb
	, substr(mem, 19,5)  mem_free
									
from  (
select replace(hostname, '[', '') hostname
	, to_timestamp('2018-'|| split_part(trim(t), '|', 2), 'yyyy-dd-mm hh24:mi:ss') tm 
	, split_part(t, '|', 3) cpu  
	, split_part(t, '|', 4) disk  
	, split_part(t, '|', 5) net 
	, split_part(t, '|', 6) mem  
from   dba.ext_sys_201801  
) aa;
