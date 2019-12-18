. /data/dba/.bash_profile

CHKYN=`psql -Atc "select case when count(*) = 0 then 'Y' else 'N' end from gp_segment_configuration where hostname not in ('smdw', 'smdw', 'mdw', 'mdw') and status <> 'u';"`

echo $CHKYN

if [ $CHKYN != "Y" ]; then
logger -i -p user.emerg "GP:WARNING One of segments is down."
echo ""
fi
