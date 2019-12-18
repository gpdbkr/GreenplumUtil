. /data/dba/.bash_profile

CHKYN=`psql -Atc "select case when count(*) =0 then 'Y' else 'N' end from gp_segment_configuration where hostname in ('smdw', 'smdw') and status <> 'u';"`

echo $CHKYN

if [ $CHKYN != "Y" ]; then
logger -i -p user.emerg "GP:WARNING Master mirroring is not syncronized."
echo ""
fi
