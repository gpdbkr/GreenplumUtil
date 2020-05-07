create schema striim;

create table striim.cms_im_lothold_his_ic
( 
lot_hold_id varchar(50) not null,
hold_tm varchar(14) not null,
crt_tm timestamp not null,
crt_user_id varchar(50) not null,
chg_tm timestamp not null,
chg_user_id varchar(50) not null,
hold_stat_cd varchar(50) not null,
fab_id varchar(50),
owner_fab_id varchar(50),
release_operator_user_id varchar(50),
wf_cnt numeric
)
distributed by (lot_hold_id, hold_tm);

alter table striim.cms_im_lothold_his_ic add primary key (lot_hold_id, hold_tm);

