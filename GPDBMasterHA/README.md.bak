# Greenplum Master failover
- This is for master HA of Greenplum database
- Configuration: If the Greenplum database is installed on cloud as vSphere, You need to disable vmotion.

# File information
|File path            |File name                | Description                        | Node  |
|---------------------|-------------------------|------------------------------------|------ |
|/usr/local/bin       |gpfailover.sh            | Daemon for GPDB Master HA on smdw  | smdw  |
|                     |gpfailovershutdown.sh    |Shutdown Daemon                     | smdw  |
|                     |vip_env.sh               |Shutdown Daemon                     | mdw,smdw  |
|                     |vip_start.sh             |Start vip                           | mdw,smdw  |
|                     |vip_stop.sh              |Stop vip                            | mdw,smdw  |
|/etc/rc.d/rc3.d/     |vip                      | mdw,smdw                           | mdw,smdw  |
|                     |gpfailover               |gpfailover service                  | smdw  |
|/etc/rc.d/rc3.d/     |s99gpfailover            |Auto Damon Start when system reboot | smdw  |
