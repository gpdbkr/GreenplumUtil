psql -c "delete from striim.cms_im_lothold_his_ic;" -d pocdb
psql -c "delete from striim.cms_im_lothold_his_ic_stg;" -d pocdb
psql -c "truncate table public.cdc_log;" -d pocdb
psql -c "select count(*) from striim.cms_im_lothold_his_ic_stg;" -d pocdb