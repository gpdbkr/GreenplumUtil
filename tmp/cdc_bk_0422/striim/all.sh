./stop_kafka_load.sh teststriim
./remove_kafka_load.sh teststriim
./init.sh 
sleep 10
./submit_kafka_load.sh teststriim striim.cms_im_lothold_his_ic_stg.yaml.teststriim
./start_kafka_load.sh teststriim
./list_kafka_load.sh

# gpsscli load striim.cms_im_lothold_his_ic_stg.yaml -f
# gpsscli start teststriim
# gpsscli start teststriim