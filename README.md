Fixed and updated sample implementations from the book "Apache Kafka"
=====================================================================
* Updated to Apache Kafka 0.8.1.1
* Configuration optimized for usage on Windows machines
* Windows batch scripts fixed (taken from https://github.com/HCanber/kafka by @HCanber)
* Code examples repaired and refactored

Initial Setup
-------------
1. [Download and install Apache Kafka](http://kafka.apache.org/downloads.html) 0.8.1.1 (I used the recommended [Scala 2.9.2 binary](https://www.apache.org/dyn/closer.cgi?path=/kafka/0.8.1.1/kafka_2.9.2-0.8.1.1.tgz))
2. Copy the scripts from [/bat](/bat) into `/bin/windows` of your Kafka installation folder (overwrite existing scripts)
3. Copy the property files from [/config](/config) into `/config` of your Kafka installation folder (overwrite existing files) 

Simple Java Producer (Chapter 5, Page 35ff.)
--------------------------------------------
1. Open command line in your Kafka installation folder
2. Launch Zookeeper with `.\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties`
3. Open a second command line in your Kafka installation folder
4. Launch single Kafka broker: `.\bin\windows\kafka-server-start.bat .\config\server.properties`
5. Open a third command line in your Kafka installation folder
6. Create a topic: `.\bin\windows\kafka-topics.bat --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test`
7. Start a console consumer for that topic: `.\bin\windows\kafka-console-consumer.bat --zookeeper localhost:2181 --topic test --from-beginning`
8. From a fourth command line or your IDE run [SimpleProducer](/src/test/kafka/SimpleProducer.java) with topic and message as arguments: `java SimpleProducer test HelloKafka`
9. The message _HelloKafka_ should appear in the console consumer's log

Java Producer with Message Partitioning (Chapter 5, Page 37ff.)
---------------------------------------------------------------
1. Open command line in your Kafka installation folder
2. Launch Zookeeper with `.\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties`
3. Open a second command line in your Kafka installation folder
4. Launch first Kafka broker: `.\bin\windows\kafka-server-start.bat .\config\server-1.properties`
5. Open a third command line in your Kafka installation folder
4. Launch second Kafka broker: `.\bin\windows\kafka-server-start.bat .\config\server-2.properties`
5. Open a fourth command line in your Kafka installation folder
6. Create a topic: `.\bin\windows\kafka-topics.bat --create --zookeeper localhost:2181 --replication-factor 2 --partitions 4 --topic test`
7. Start a console consumer for that topic: `.\bin\windows\kafka-console-consumer.bat --zookeeper localhost:2181 --topic test --from-beginning`
8. From a fifth command line or your IDE run [MultiBrokerProducer](/src/test/kafka/MultiBrokerProducer.java) with topic as argument: `java MultiBrokerProducer test`
9. Ten messages starting with _This message is for key (...)_ should appear in the console consumer's log

Simple High Level Java Consumer (Chapter 6, Page 47ff.)
-------------------------------------------------------
1. Launch multi-broker Kafka cluster and create topic `test` as described in step 1-6 of __Java Producer with Message Partitioning__
2. From another command line or your IDE run [SimpleHLConsumer](/src/test/kafka/consumer/SimpleHLConsumer.java) with topic as argument: `java SimpleHLConsumer test`
3. From another command line or your IDE run [MultiBrokerProducer](/src/test/kafka/MultiBrokerProducer.java) with same topic as argument: `java MultiBrokerProducer test`
4. Ten messages starting with _This message is for key (...)_ should appear in the log of the __SimpleHLConsumer__ 

Multithreaded Consumer for Multipartition Topics (Chapter 6, Page 50ff.)
------------------------------------------------------------------------
1. Launch multi-broker Kafka cluster and create topic `test` as described in step 1-6 of __Java Producer with Message Partitioning__
2. From another command line or your IDE run [MultiThreadHLConsumer](/src/test/kafka/consumer/MultiThreadHLConsumer.java) with topic and number of threads as argument: `java MultiThreadHLConsumer test 4`
3. From another command line or your IDE run [MultiBrokerProducer](/src/test/kafka/MultiBrokerProducer.java) with same topic as argument: `java MultiBrokerProducer test`
4. Ten messages starting with _Message from thread (...)_ should appear in the log of the __MultiThreadHLConsumer__

[![endorse](https://api.coderwall.com/bkimminich/endorsecount.png)](https://coderwall.com/bkimminich)