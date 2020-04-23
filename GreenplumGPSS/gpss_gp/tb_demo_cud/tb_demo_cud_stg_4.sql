--truncate table gpss_test.tb_demo_cud_stg;

insert into gpss_test.tb_demo_cud_stg values (21, 'A', 'A', 'A', now(), 'I');
insert into gpss_test.tb_demo_cud_stg values (21, 'B', NULL, NULL, now(), 'U');
insert into gpss_test.tb_demo_cud_stg values (21, NULL, NULL, NULL, now(), 'D');
insert into gpss_test.tb_demo_cud_stg values (21, 'C', 'C', 'C', now(), 'I');
insert into gpss_test.tb_demo_cud_stg values (21, NULL, 'D', NULL, now(), 'U');
insert into gpss_test.tb_demo_cud_stg values (21, NULL, 'E', NULL, now(), 'U');

insert into gpss_test.tb_demo_cud_stg values (22, 'A', 'A', 'A', now(), 'I');
insert into gpss_test.tb_demo_cud_stg values (22, 'B', NULL, NULL, now(), 'U');
insert into gpss_test.tb_demo_cud_stg values (22, NULL, 'C', NULL, now(), 'U');
insert into gpss_test.tb_demo_cud_stg values (22, 'D', NULL, NULL, now(), 'U');
insert into gpss_test.tb_demo_cud_stg values (22, NULL, NULL, 'B', now(), 'U');
insert into gpss_test.tb_demo_cud_stg values (22, 'B1', NULL, NULL, now(), 'U');

SELECT * from gpss_test.tb_demo_cud_stg order by gpss_ts;
