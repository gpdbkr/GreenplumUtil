if [ $# -ne 2 ] ; then
  echo "Usage : " $0 "topicname uploadfile"
  exit
fi

/usr/local/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic $1 < $2
