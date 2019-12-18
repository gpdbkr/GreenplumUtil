CREATE TABLE dba.sql_history
(
    event_time timestamp without time zone,
    user_name character varying(100),
    database_name character varying(100),
    process_id character varying(10),
    remote_host character varying(20),
    session_start_time timestamp with time zone,
    gp_session_id character varying(20),
    gp_command_count character varying(20),
    debug_query_string text,
    elapsed_ms numeric,
    log_tp character varying(10),
    state_cd character varying(10),
    dtl_msg text
)
WITH (
appendonly=true, compresslevel=5, compresstype=zlib
)
DISTRIBUTED BY (event_time)
PARTITION BY RANGE(event_time)
(
    PARTITION p201801 START ('2018-01-01 00:00:00'::timestamp) END ('2018-02-01 00:00:00'::timestamp),
    PARTITION p201802 START ('2018-02-01 00:00:00'::timestamp) END ('2018-03-01 00:00:00'::timestamp),
    PARTITION p201803 START ('2018-03-01 00:00:00'::timestamp) END ('2018-04-01 00:00:00'::timestamp),
    PARTITION p201804 START ('2018-04-01 00:00:00'::timestamp) END ('2018-05-01 00:00:00'::timestamp),
    PARTITION p201805 START ('2018-05-01 00:00:00'::timestamp) END ('2018-06-01 00:00:00'::timestamp),
    PARTITION p201806 START ('2018-06-01 00:00:00'::timestamp) END ('2018-07-01 00:00:00'::timestamp),
    PARTITION p201807 START ('2018-07-01 00:00:00'::timestamp) END ('2018-08-01 00:00:00'::timestamp),
    PARTITION p201808 START ('2018-08-01 00:00:00'::timestamp) END ('2018-09-01 00:00:00'::timestamp),
    PARTITION p201809 START ('2018-09-01 00:00:00'::timestamp) END ('2018-10-01 00:00:00'::timestamp),
    PARTITION p201810 START ('2018-10-01 00:00:00'::timestamp) END ('2018-11-01 00:00:00'::timestamp),
    PARTITION p201811 START ('2018-11-01 00:00:00'::timestamp) END ('2018-12-01 00:00:00'::timestamp),
    PARTITION p201812 START ('2018-12-01 00:00:00'::timestamp) END ('2019-01-01 00:00:00'::timestamp),
    PARTITION p201901 START ('2019-01-01 00:00:00'::timestamp) END ('2019-02-01 00:00:00'::timestamp),
    PARTITION p201902 START ('2019-02-01 00:00:00'::timestamp) END ('2019-03-01 00:00:00'::timestamp),
    PARTITION p201903 START ('2019-03-01 00:00:00'::timestamp) END ('2019-04-01 00:00:00'::timestamp),
    PARTITION p201904 START ('2019-04-01 00:00:00'::timestamp) END ('2019-05-01 00:00:00'::timestamp),
    PARTITION p201905 START ('2019-05-01 00:00:00'::timestamp) END ('2019-06-01 00:00:00'::timestamp),
    PARTITION p201906 START ('2019-06-01 00:00:00'::timestamp) END ('2019-07-01 00:00:00'::timestamp),
    PARTITION p201907 START ('2019-07-01 00:00:00'::timestamp) END ('2019-08-01 00:00:00'::timestamp),
    PARTITION p201908 START ('2019-08-01 00:00:00'::timestamp) END ('2019-09-01 00:00:00'::timestamp),
    PARTITION p201909 START ('2019-09-01 00:00:00'::timestamp) END ('2019-10-01 00:00:00'::timestamp),
    PARTITION p201910 START ('2019-10-01 00:00:00'::timestamp) END ('2019-11-01 00:00:00'::timestamp),
    PARTITION p201911 START ('2019-11-01 00:00:00'::timestamp) END ('2019-12-01 00:00:00'::timestamp),
    PARTITION p201912 START ('2019-12-01 00:00:00'::timestamp) END ('2020-01-01 00:00:00'::timestamp),
    DEFAULT PARTITION pother
)
