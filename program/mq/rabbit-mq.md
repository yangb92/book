# RabbitMQ

使用 erlang 语言开发, 基于 AMQP( Advanced Message Queue ) 协议.

## 安装及配置

### 安装

docker-compose 安装 rabbitmq

```yml
version: '3'
services:
  #服务名称
  rabbitmq:
    #容器名称
    container_name: rabbitmq
    #镜像名称
    image: rabbitmq:3.7-rc
    #总是重启后启动
    restart: always
    #端口映射
    ports:
      - 5672:5672
      - 15672:15672
    #挂载
    volumes:
      - ./data:/var/lib/rabbitmq
    #环境变量
    environment:
      - RABBITMQ_DEFAULT_VHOST=my_vhost
      - RABBITMQ_DEFAULT_USER=admin
      - RABBITMQ_DEFAULT_PASS=admin
```

开启管理界面

```sh
docker exec 3606dab88713 rabbitmq-plugins enable rabbitmq_management
```

输入 http://192.168.10.45:15672 登录mq管理界面.

### 配置

**(1) Virtual Host**

每个虚拟主机之间是相互独立的.

