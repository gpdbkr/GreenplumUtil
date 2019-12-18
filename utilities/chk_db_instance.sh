. /data/dba/.bash_profile

export PGHOST=12.30.45.159
export PGDATABASE=postgres

CHKYN=`psql -Atc "select 'Y' ;"`
if [ $CHKYN = "Y" ]; then
DBSTATUS="DATABASE IS Normal!!!"
else 
DBSTATUS="Warning!! Databse is gone!!!"
fi
echo $DBSTATUS

if [ $CHKYN != "Y" ]; then
logger -i -p user.emerg "GP:WARNING Greenplum was stopped."
echo ""
fi
