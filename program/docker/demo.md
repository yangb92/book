# Docker 实战

## 前后分离项目结构

目录结构
```
html
  -|cadre-pc
  -|cadre-wx
  -|Dockerfile
  -|nginx.conf
server
  -|cadre-msg.jar
  -|Dockerfile
docker-compose.yml
.env
```

html-Dockerfile
```dockerfile
FROM nginx

MAINTAINER YangBin

COPY nginx.conf /etc/nginx/nginx.conf

COPY cadre-wx /app/cadre-wx

COPY cadre-pc /app/cadre-pc

EXPOSE 80
```

html-nginx.conf

```nginx
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

  server {
    listen       80;
    server_name  localhost;

    charset utf-8;
    #access_log  /var/log/nginx/host.access.log  main;

    location ~ ^/cadre-wx+ {
        root /app;
    }
    location ~ ^/cadre-pc+ {
        root /app;
    }
    location ~ ^/cadre-msg+ {
        proxy_pass http://cadre-msg:15068;
    }

  }
}

```

server-Dockerfile

```dockerfile
FROM openjdk:8-jre

MAINTAINER YangBin <http://yangb.xyz>

COPY cadre-msg.jar /app/app.jar

ENTRYPOINT ["java","-jar","/app/app.jar"]

EXPOSE 15068
```

docker-compose.yml

```yml
version: '3'

services: 
    cadre-msg:
        build: ./server
        container_name: cadre-msg
        networks: 
            - cadre
        expose: 
            - 15068
        
    cadre-html:
        build: ./html
        container_name: cadre-html
        networks: 
            - cadre
        ports: 
            - '${SERVER-PORT:-12580}:80'

networks: 
    cadre: 

```

.env

```properties
SERVER-PORT=12580
```

部署:

```bash
docker-compose up -d
```

访问以下地址:

```
http://192.168.10.45:10085/cadre-wx/
```





## Tomcat

```yml
version: '3.1'
services:
  tomcat:
    restart: always
    image: tomcat
    container_name: tomcat
    ports:
      - 8080:8080
    volumes:
      - /usr/local/docker/tomcat/webapps/test:/usr/local/tomcat/webapps/test
    environment:
      TZ: Asia/Shanghai
```

## MySql

### MySQL5

```yml
version: '3.1'
services:
  mysql:
    restart: always
    image: mysql:5.7.22
    container_name: mysql
    ports:
      - 3306:3306
    environment:
      TZ: Asia/Shanghai
      MYSQL_ROOT_PASSWORD: 123456
    command:
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_general_ci
      --explicit_defaults_for_timestamp=true
      --lower_case_table_names=1
      --max_allowed_packet=128M
      --sql-mode="STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO"
    volumes:
      - mysql-data:/var/lib/mysql

volumes:
  mysql-data:
```



### MySQL8

```yml
version: '3.1'
services:
  db:
    image: mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: 123456
    command:
      --default-authentication-plugin=mysql_native_password
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_general_ci
      --explicit_defaults_for_timestamp=true
      --lower_case_table_names=1
    ports:
      - 3306:3306
    volumes:
      - ./data:/var/lib/mysql

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
```