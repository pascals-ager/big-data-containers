## Images to build a clustered, unsecured, Big Data development environment

# Components:
	HDFS/Yarn - 2.8.4 (1 Namenode, 3 Datanodes)
	Hive - 3.1.2 with Postgres 9.5 metastore
	Spark on Yarn - 2.4.4
	Nifi - 1,7.1, 1.9.2, 1.10.0
	Kafka/ZK - 2.3.1/3.4.14
	Kafka Schema Registry 
	Nifi Registry


* build the containers
```
docker-compose build

docker-compose up node-master node-one node-two node-three

## wait till the three nodes are up and healthy

docker-compose up postgresql-metastore-three hive-server-three hive-metastore-three kafka-zk schema-registry 

docker-compose up nifi-one-dot-nine
```

Networking prerequisites:

	1. Since we want to create multiple clusters running with named container services on different networks, an easy solution is to assign each cluster its subnet. Hence extra hosts are added to the container services.
	2. These IP addresses may be added to /etc/hosts to access the container services using IP:PORT instead of container names


JMX connections to NIFI:

	1. JMX connection may be added at port 19092 

Hive:

	1. via beeline - !connect jdbc:hive2://hive-server-three:10000/default (usr/pwd - hive/hive )



node-master:

	1. YARN RM dashboard can be - 8088
	2. Hadoop Namenode administration dashboard - 50070

nifi:
```
	1. nifi - 8080
	2. nifi-one-dot-nine - 8083
	3. nifi-one-dot-ten - 8085
```	


