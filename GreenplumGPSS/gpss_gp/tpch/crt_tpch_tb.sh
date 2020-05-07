psql -e << +

create schema tpch;
create schema tpch_stg;

CREATE TABLE tpch.customer (
	c_custkey int4 NOT NULL,
	c_name varchar(25) NOT NULL,
	c_address varchar(40) NOT NULL,
	c_nationkey int4 NOT NULL,
	c_phone bpchar(15) NOT NULL,
	c_acctbal numeric(15,2) NOT NULL,
	c_mktsegment bpchar(10) NOT NULL,
	c_comment varchar(117) NOT NULL
)
DISTRIBUTED by (c_custkey);

alter table tpch.customer add constraint pk_customer primary key (c_custkey);

CREATE TABLE gpss_stg.stg_tpch_customer (
	c_custkey int4 NOT NULL,
	c_name varchar(25) ,
	c_address varchar(40) ,
	c_nationkey int4 ,
	c_phone bpchar(15) ,
	c_acctbal numeric(15,2),
	c_mktsegment bpchar(10),
	c_comment varchar(117) ,
	gpss_fg   varchar(10),
	gpss_ts   timestamp
)
DISTRIBUTED by (c_custkey);


CREATE TABLE gpss_stg.tmp_tpch_customer (
	m json,
	d json,
	gpss_ts   timestamp
)
DISTRIBUTED randomly;


CREATE TABLE tpch.orders (
	o_orderkey int8 NOT NULL,
	o_custkey int4 ,
	o_orderstatus bpchar(1) ,
	o_totalprice numeric(15,2) ,
	o_orderdate date ,
	o_orderpriority bpchar(15) ,
	o_clerk bpchar(15) ,
	o_shippriority int4 ,
	o_comment varchar(79) 
)
DISTRIBUTED BY (o_orderkey)

alter table tpch.orders add constraint pk_orders primary key (o_orderkey);

CREATE unlogged  TABLE gpss_stg.stg_tpch_orders (
	o_orderkey int8 NOT NULL,
	o_custkey int4 ,
	o_orderstatus bpchar(1) ,
	o_totalprice numeric(15,2) ,
	o_orderdate date ,
	o_orderpriority bpchar(15) ,
	o_clerk bpchar(15) ,
	o_shippriority int4 ,
	o_comment varchar(79),
	gpss_fg varchar(10),
	gpss_ts timestamp
)
DISTRIBUTED BY (o_orderkey);

CREATE unlogged  TABLE gpss_stg.tmp_tpch_orders (
	m json,
	d json,
	gpss_ts   timestamp
)
DISTRIBUTED randomly;

+
