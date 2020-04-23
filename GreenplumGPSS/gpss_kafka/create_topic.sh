if [ $# -ne 1 ] ; then
  echo "Usage : " $0 "topicname"
  exit
fi

/usr/local/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic $1
