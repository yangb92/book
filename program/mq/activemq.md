# ActiveMQ

消息中间件

## SpringBoot 项目

### pom.xml

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-activemq</artifactId>
</dependency>
```

### application.yml

```yml
spring:
  activemq:
    broker-url: tcp://47.98.63.50:61616
    user: admin
    password: admin
    in-memory: true
    pool:
      enabled: false
    packages: # 如果消息体是一个对象，则需要设置对象所在的包为信任。
      trusted: com.yangb.rabbitmq.dto
#      trust-all: true  # 信任所有对象

```

### 消息队列发送

```java
    @Bean
    public ActiveMQQueue queue(){
        return new ActiveMQQueue("data.exchange.queue");
    }
```

```java
@Component
public class Sender {

    @Autowired
    ActiveMQQueue queue;

    @Autowired
    JmsTemplate jmsTemplate;

    public void sendMessage(String message){
        jmsTemplate.convertAndSend(queue,new MessageDto(1, message, false));
    }
}
```

### 消息队列接收

```java
@Component
public class Recever {

    @JmsListener(destination = "data.queue")
    public void receveQueue(MessageDto message){
        System.out.println("收到消息:"+message.getMessage());
    }

}
```

### 广播发送

```java
    @Bean
    public ActiveMQTopic topic(){
        return new ActiveMQTopic("data.exchange.topic");
    }
```

```java
    @Autowired
    ActiveMQTopic topic;

    public void sendTopic(String message){
        jmsTemplate.convertAndSend(topic,new MessageDto(1, message, false));
    }
```

### 广播接收

```java
    @JmsListener(destination = "data.exchange.topic")
    public void receveTopic(MessageDto message) {
        System.out.println("收到广播:" + message.getMessage());
    }
```