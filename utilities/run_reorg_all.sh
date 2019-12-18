#. ~/.bash_profile


CHECK_CNT=300

while [ $CHECK_CNT -ge 0 ]
do

    ## checking list to run reorg
    REORG_YN=`psql -AtXc " select count(*) from gp_toolkit.gp_bloat_diag where bdinspname not in ('pg_catalog');"`
    echo "The number of reorg table needed : "$REORG_YN
    if [ $REORG_YN -eq 0 ] 
    then
        exit 0
    fi

    ## checking session
    SESSION_YN=`psql -AtXc "select count(*) from dba.pg_stat_activity()  where current_query not like '%IDLE%';"`
    echo "The number of current session : " $SESSION_YN
    
    if [ $SESSION_YN -eq 0 ] 
    then
        psql -AtXc " select 'alter table '||bdinspname||'.'||bdirelname|| ' set with(reorganize=true) ; analyze '||bdinspname||'.'||bdirelname||';' from gp_toolkit.gp_bloat_diag where bdinspname not in ('pg_catalog') limit 1;" | psql -e
    fi

    sleep 1
    CHECK_CNT=`expr $CHECK_CNT - 1`
    echo "The number of times to check session : " $CHECK_CNT
done
