# Docker 网络配置

docker-compose 容器之间的相互通信, 配置同一块网卡, 容器访问的时候例如`business-order:8002`使用服务.

```yml
  business-order:
    build: ./business-order
    restart: always
    container_name: razor-business-order
    extra_hosts:
      - 'mysql-server:192.168.10.45'
    networks:
      - razor-net
    expose:
      - 8002
    depends_on:
      - serve-discover

  business-payment:
    build: ./business-payment
    restart: always
    container_name: razor-business-payment
    extra_hosts:
      - 'mysql-server:192.168.10.45'
    networks:
      - razor-net
    expose:
      - 8001
    depends_on:
      - serve-discover

networks:
  razor-net:
```



