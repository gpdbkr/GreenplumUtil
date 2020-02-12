#!/bin/bash

### confirm gpdb status
echo "Is current GPDB started?"
echo -n "vip_env.sh modified? "
read re
if [ $re = "y" ] || [ $re = "Y" ];then

### Copy Files - mdw
mkdir /usr/local/bin
cp *.sh /usr/local/bin/
chown gpadmin /usr/local/bin/*
cp vip /etc/rc.d/init.d/
chown gpadmin /etc/rc.d/init.d/vip
echo "1. Copy Files - mdw : OK"

### Copy Files - smdw
ssh root@smdw 'mkdir /usr/local/bin'
scp *.sh smdw:/usr/local/bin/
ssh root@smdw 'chown gpadmin /usr/local/bin/*'
scp vip smdw:/etc/rc.d/init.d/
ssh root@smdw 'chown gpadmin /etc/rc.d/init.d/vip'
scp S99gpfailover smdw:/etc/rc.d/rc3.d/
ssh root@smdw 'chown gpadmin /etc/rc.d/rc3.d/S99gpfailover'
scp gpfailover smdw:/etc/rc.d/init.d/
ssh root@smdw 'chown gpadmin /etc/rc.d/init.d/gpfailover'
echo "2. Copy Files - smdw : OK"

### smdw .bash_profile modify
a=$(ssh root@smdw 'cat /home/gpadmin/.bash_profile | grep "/usr/local/greenplum-db/greenplum_path.sh" | wc -l')
if [ "$a" == "0" ];then
	ssh root@smdw 'echo ". /usr/local/greenplum-db/greenplum_path.sh" >> /home/gpadmin/.bash_profile'
fi

b=$(ssh root@smdw 'cat /home/gpadmin/.bash_profile | grep "export MASTER_DATA_DIRECTORY=/data/master/gpseg-1" | wc -l')
if [ "$b" == "0" ];then
	ssh root@smdw 'echo "export MASTER_DATA_DIRECTORY=/data/master/gpseg-1" >> /home/gpadmin/.bash_profile'
fi
c=$(ssh root@smdw 'cat /home/gpadmin/.bash_profile | grep "export PGPORT=5432" | wc -l')
if [ "$c" == "0" ];then
	ssh root@smdw 'echo "export PGPORT=5432" >> /home/gpadmin/.bash_profile'
fi
echo "3. smdw .bash_profile modify : OK"

### confirm gpdb status 

### service daemon setup
./vip_start.sh
echo "4. mdw vip_start : OK"
ssh root@smdw 'service start gpfailover'
echo "5. smdw service : OK"

else
echo "Please, confirm gpdb, vip_env.sh!!!"
fi
