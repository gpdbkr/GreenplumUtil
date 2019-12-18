#!/bin/sh

# File Prefix and Suffix
prefix=vac_freeze_template0
suffix=out

# File Time Stamp
now=`date +%Y%m%d_%H%M%S_%N`

# Get segments host and port
sql_segments="select hostname || ' ' || port from gp_segment_configuration where preferred_role = 'p'"

# SQL to do on each segment
sql_vac_freeze="
select datname, age(datfrozenxid) from pg_database where datname = 'template0';
set allow_system_table_mods=on;
update pg_database set datallowconn='t' where datname = 'template0';
\c template0
vacuum freeze;
set allow_system_table_mods=on;
update pg_database set datallowconn='f' where datname = 'template0';
select datname, age(datfrozenxid) from pg_database where datname = 'template0';
"

export PGOPTIONS="-c gp_session_role=utility"
 
# Loop over segments
psql -Atc "${sql_segments}" postgres | while read host port;
  do
    echo "PROCESSING ${host}, ${port}";
    nohup psql -a -h ${host} -p ${port} postgres > ./log/${prefix}_${host}_${port}.${now}.${suffix} 2>&1 <<EOF &
    ${sql_vac_freeze}
EOF
done

export PGOPTIONS=""

