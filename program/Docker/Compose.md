# Docker Compose

学习地址<https://www.funtl.com/zh/docker-compose/>

Docker 三剑客之一, **必会**. 负责实现对Docker集群的快速编排. 

## 安装

`Compose` 支持 Linux、macOS、Windows 10 三大平台。`Compose` 可以通过 Python 的包管理工具 `pip` 进行安装

## 二进制包

```bash
$ sudo curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

## PIP 安装

```bash
$ sudo pip install -U docker-compose
```

测试

```bash
docker-compose version
```

## bash 补全命令

```bash
$ curl -L https://raw.githubusercontent.com/docker/compose/1.8.0/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
```

## 容器中执行

Compose 既然是一个 Python 应用，自然也可以直接用容器来执行它。

```bash
$ curl -L https://github.com/docker/compose/releases/download/1.8.0/run.sh > /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
```

## 卸载

如果是二进制包方式安装的，删除二进制文件即可。

```bash
$ sudo rm /usr/local/bin/docker-compose
```

如果是通过 `pip` 安装的，则执行如下命令即可删除。

```bash
$ sudo pip uninstall docker-compose
```



## 基本使用

编写`docker-compose.yml` 这个是Compose使用的主模板文件

```yml
version: '3'

services:
  tomcat:
    restart: always
    image: tomcat
    container_name: tomcat
    ports:
      - 80:8080
```

运行compose项目

```sh
docker-compose up
```

