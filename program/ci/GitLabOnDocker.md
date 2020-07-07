# Gitlab Docker 安装

# Gitlab Docker安装

## 获取Gitlab镜像

汉化版的gitlab

```sh
docker pull twang2218/gitlab-ce-zh
```

## docker-compose.yml 配置gitlab

在 `/usr/local/docker/gitlab`'目录下,创建`docker-compose.yml`文件

```yml
version: '3'

services:
  web:
    image: 'twang2218/gitlab-ce-zh'
    restart: always
    hostname: 'gitlab.yangb.xyz'
    environment:
      TZ: 'Asia/Shanghai'
      GITLAB_OMNIBUS_CONFIG: |
              external_url 'http://gitlab.yangb.xyz'
    prots:
      - '80:80'
      - '443:443'
      - '22:22'
    volumes:
      - /usr/local/docker/gitlab/config:/etc/gitlab
      - /usr/local/docker/gitlab/data:/var/opt/gitlab
      - /usr/local/docker/logs:/var/log/gitlab
```
自定端口配置 
```yml
 GITLAB_OMNIBUS_CONFIG: | 
              external_url 'http://gitlab.yangb.xyz:8080' # 访问地址和端口
              gitlab_rails['gitlab_shell_ssh_port'] = 2222 # ssh 访问端口,免密访问
              unicorn['port'] = 8888 # 内部端口
              nginx['listen_port'] = 8080 # nginx端口和上面端口需要一致

 ports: #上面端口映射关系
  - '8080:8080'
  - '8443:443'
  - '2222:22'
```