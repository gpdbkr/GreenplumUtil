INSERT INTO public.template_src_stg
(
  id
, z_cdc_ts
, c3
, c2
, c1
)
WITH tmp AS
(
     SELECT *
       FROM (
                 SELECT
                     id
--                   , z_cdc_ts
                   , c3
                   , c2
                   , c1
                   , z_cdc_ts
                   , z_cud_fg
                   , row_number() over (partition by id
                                           order by z_cdc_ts desc) rnk
 from public.template_src_stg a
             where a.z_cud_fg in ('INSERT','DELETE')
               and z_cdc_ts >= '2020-01-01'
               and z_cdc_ts <= '2020-04-05'
             ) a
     where z_cud_fg = 'INSERT'
       and rnk = 1
)
select
       a.id
     , a.z_cdc_ts
     , a.c3
     , a.c2
     , a.c1
  from tmp a
  left outer join public.template_src b
    on a.id                        = b.id
 where b.id                        is null
;

