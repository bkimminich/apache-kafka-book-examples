package test.kafka.consumer;

import kafka.consumer.Consumer;
import kafka.consumer.ConsumerConfig;
import kafka.consumer.KafkaStream;
import kafka.javaapi.consumer.ConsumerConnector;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MultiThreadHLConsumer {

    private ExecutorService executor;
    private final ConsumerConnector consumer;
    private final String topic;

    public MultiThreadHLConsumer(String zookeeper, String groupId, String topic) {
        Properties properties = new Properties();
        properties.put("zookeeper.connect", zookeeper);
        properties.put("group.id", groupId);
        properties.put("zookeeper.session.timeout.ms", "500");
        properties.put("zookeeper.sync.time.ms", "250");
        properties.put("auto.commit.interval.ms", "1000");

        consumer = Consumer.createJavaConsumerConnector(new ConsumerConfig(properties));
        this.topic = topic;
    }

    public void testConsumer(int threadCount) {
        Map<String, Integer> topicCount = new HashMap<>();
        topicCount.put(topic, threadCount);

        Map<String, List<KafkaStream<byte[], byte[]>>> consumerStreams = consumer.createMessageStreams(topicCount);
        List<KafkaStream<byte[], byte[]>> streams = consumerStreams.get(topic);

        executor = Executors.newFixedThreadPool(threadCount);

        int threadNumber = 0;
        for (final KafkaStream stream : streams) {
            executor.submit(new ConsumerThread(stream, threadNumber));
            threadNumber++;
        }

        try { // without this wait the subsequent shutdown happens immediately before any messages are delivered
            Thread.sleep(10000);
        } catch (InterruptedException ie) {

        }
        if (consumer != null) {
            consumer.shutdown();
        }
        if (executor != null) {
            executor.shutdown();
        }
    }

    public static void main(String[] args) {
        String topic = args[0];
        int threadCount = Integer.parseInt(args[1]);
        MultiThreadHLConsumer multiThreadHLConsumer = new MultiThreadHLConsumer("localhost:2181", "testgroup", topic);
        multiThreadHLConsumer.testConsumer(threadCount);
    }

}
