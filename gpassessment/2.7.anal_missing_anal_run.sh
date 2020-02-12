#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

psql -AXtc "
select 'analyze '||schema_nm||'.'|| table_nm ||';' as an
from  (
       select smischema schema_nm,smitable table_nm, smisize ,smicols , smirecs
            , pg_relation_size(smischema||'.'||smitable)/1024 table_real_size_kb  
       from   gp_toolkit.gp_stats_missing 
) a
where table_real_size_kb > 1
order by 1;
" |psql -e | tee  $LOGFILE


