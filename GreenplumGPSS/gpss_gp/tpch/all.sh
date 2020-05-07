./job_stop.sh tpch.customer
./job_remove.sh tpch.customer
sleep 1
./job_submit.sh tpch.customer
./job_start.sh tpch.customer e
./job_list.sh
