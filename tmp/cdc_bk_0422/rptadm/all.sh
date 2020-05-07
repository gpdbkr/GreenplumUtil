./stop_kafka_load.sh rptadm.durable
./remove_kafka_load.sh rptadm.durable
./init.sh
./submit_kafka_load.sh rptadm.durable rptadm.durable.yaml
./start_kafka_load.sh rptadm.durable --force-reset-latest
./list_kafka_load.sh

# gpsscli load rptadm.durable_stg.yaml -f
# gpsscli start teststriim --force-reset-latest --quit-at-eof
# gpsscli start teststriim
