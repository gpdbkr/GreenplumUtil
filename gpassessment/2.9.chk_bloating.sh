#!/bin/bash

SHELL_NM=$0
CURDIR=`pwd`
LOGDIR=$CURDIR"/"log
LOGFILE=$LOGDIR"/"$SHELL_NM".log"
mkdir -p $LOGDIR

echo "" >  $LOGFILE

psql -ec "
select bdinspname schema_nm, bdirelname tb_nm, bdirelpages*32/1024 real_size_mb, bdiexppages*32/1024 exp_size_mb from gp_toolkit.gp_bloat_diag where bdirelpages*32/1024 > 100;
" | tee  $LOGFILE

