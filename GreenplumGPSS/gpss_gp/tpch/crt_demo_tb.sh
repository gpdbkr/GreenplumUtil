psql -e << +

create schema gpss_test;

drop table if exists gpss_test.tb_demo_cud_src;

create table gpss_test.tb_demo_cud_src
(
	id int,
	c1 varchar(20),
	c2 varchar(20),
	c3 varchar(20),
	gpss_ts timestamp
)
distributed by (id);

alter table gpss_test.tb_demo_cud_src add constraint pk_tb_demo_cud_src primary key (id);


drop table if exists gpss_test.tb_demo_cud_target;

create table gpss_test.tb_demo_cud_target
(
	id int,
	c1 varchar(20),
	c2 varchar(20),
	c3 varchar(20),
	gpss_ts timestamp
)
distributed by (id);
alter table gpss_test.tb_demo_cud_target add constraint pk_tb_demo_cud_target primary key (id);

drop table if exists gpss_test.tb_demo_cud_stg;

create table gpss_test.tb_demo_cud_stg
(
	id int,
	c1 varchar(20),
	c2 varchar(20),
	c3 varchar(20),
	gpss_ts timestamp,
        gpss_fg varchar(20)
)
distributed by (id);
+
