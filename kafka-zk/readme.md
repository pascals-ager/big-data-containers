List Topics:

./kafka-topics.sh --list --zookeeper kafka-zk:2181


Create Topics:

./kafka-topics.sh --create --zookeeper kafka-zk:2181 --replication-factor 1 --partitions 1 --topic avro-events-identification-carrier

Produce:

./kafka-console-producer.sh --broker-list kafka-zk:9092 --topic test

Consume:

./kafka-console-consumer.sh --bootstrap-server kafka-zk:9092 --topic test
