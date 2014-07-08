package test.kafka.consumer;

import kafka.consumer.ConsumerIterator;
import kafka.consumer.KafkaStream;

final class ConsumerThread implements Runnable {

    private KafkaStream stream;
    private int threadNumber;

    public ConsumerThread(KafkaStream stream, int threadNumber) {
        this.threadNumber = threadNumber;
        this.stream = stream;
    }

    public void run() {
        ConsumerIterator<byte[], byte[]> it = stream.iterator();
        while (it.hasNext()) {
            System.out.println("Message from thread " + threadNumber + ": " + new String(it.next().message()));
        }
        System.out.println("Shutting down thread: " + threadNumber);
    }

}
