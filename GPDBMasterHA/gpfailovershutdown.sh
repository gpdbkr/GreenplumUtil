ps -ef | grep -i gpfailover.sh | grep -v grep | grep -v service| awk '{print $2}' | xargs kill -11
