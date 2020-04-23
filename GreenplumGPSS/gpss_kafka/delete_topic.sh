if [ $# -ne 1 ] ; then
  echo "Usage : " $0 "topicname"
  exit
fi

/usr/local/kafka/bin/kafka-topics.sh --delete --bootstrap-server localhost:9092 --topic $1
