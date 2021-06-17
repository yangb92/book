# 消息队列 

## AMQP 和 JMS

MQ 的消息通信模型; 实现 MQ 的两种主流方式

* AMQP: 是一种协议. 定义网络交换的数据格式
* JMS: (Java message service) java消息服务.

## 消息队列产品

| 消息队列 | 实现方式     | 说明                    |
| -------- | ------------ | ----------------------- |
| ActiveMQ | JMS          |                         |
| ZeroMQ   | AMQP         | C语言                   |
| RabbitMQ | AMQP         | erlang语言              |
| RocketMQ | JMS          | Alibaba产品             |
| Kafka    | 类似MQ的产品 | 分布式消息系统,高吞吐量   |



