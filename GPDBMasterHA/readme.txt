tar xf gpdb_master_failover.tar
cd bin
chmod +x *
vi vip_env.sh   ### editing 
cp *.sh /usr/local/bin
cp vip /etc/rc.d/init.d/
cp gpfailover /etc/rc.d/init.d/

# apply to only standby master 
#cp S99gpfailover /etc/rc.d/rc3.d/
