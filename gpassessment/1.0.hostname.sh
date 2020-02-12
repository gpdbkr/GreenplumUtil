psql -AXtc "select distinct hostname from gp_segment_configuration order by 1;" > hostname.txt
