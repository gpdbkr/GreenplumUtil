if [ $# -ne 1 ] ; then
  echo "Usage : " $0 "topicname "
  exit
fi

/usr/local/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic $1  --from-beginning
