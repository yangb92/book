# Nginx

## Nginx 的主从热备

> 场景:  Nginx代理主服务器对外提供服务, 主服务器失去连接后 Nginx 代理转向从服务器为外界提供服务.  当主服务器恢复时, 自动切换至主服务器继续为外界提供服务.

Nginx 配置:

```nginx
http {
    
    upstream backend {
        server localhost:9090;
        server localhost:9999  backup;
    }

    server {
        listen 80;
        location / {
            proxy_pass http://backend;
        }

    }
}
```

