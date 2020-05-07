drop table if exists public.template_src;

create table public.template_src
(
	id int,
	c1 varchar(20),
	c2 varchar(20),
	c3 varchar(20),
	ts timestamp
)
distributed by (id);

drop table if exists public.template_target;

create table public.template_target
(
	id int,
	c1 varchar(20),
	c2 varchar(20),
	c3 varchar(20),
	ts timestamp
)
distributed by (id);

drop table if exists public.template_stg;

create table public.template_stg
(
	id int,
	c1 varchar(20),
	c2 varchar(20),
	c3 varchar(20),
	ts timestamp,
    cud_fg varchar(20)
)
distributed by (id);



drop table if exists public.cdc_log;

create table public.cdc_log 
(
	target_tb varchar(63),
	start_ts  timestamp,
	end_ts	  timestamp,
	stag_rows int,
        ins_cnt   int,
        del_cnt   int,
        up_cnt    int
)
distributed randomly;
