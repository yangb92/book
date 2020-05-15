
# Docker安装

## CentOS 安装

脚本自动安装
```sh
$ curl -fsSL get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh --mirror Aliyun
```

启动Docker

```sh
$ sudo systemctl enable docker
$ sudo systemctl start docker
```

## Ubuntu 安装

脚本自动安装:

```sh
 curl -fsSL get.docker.com -o get-docker.sh
 sh get-docker.sh --mirror Aliyun
```

检测Docker是否安装成功

```sh
docker version
```

配置阿里云Docker镜像加速器

下载镜像

```
docker pull 镜像名称
```

启动镜像

```
 docker run -p 80:8080 tomcat
```

## 建立 docker 用户组

默认情况下，docker 命令会使用 Unix socket 与 Docker 引擎通讯。而只有 root 用户和 docker 组的用户才可以访问 Docker 引擎的 Unix socket。出于安全考虑，一般 Linux 系统上不会直接使用 root 用户。因此，更好地做法是将需要使用 docker 的用户加入 docker 用户组。

建立 docker 组：
```
$ sudo groupadd docker
```
将当前用户加入 docker 组：
```
$ sudo usermod -aG docker $USER
```
退出当前终端并重新登录，进行如下测试

## 测试 Docker 是否安装正确

```bash
$ docker run hello-world

Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
ca4f61b1923c: Pull complete
Digest: sha256:be0cd392e45be79ffeffa6b05338b98ebb16c87b255f48e297ec7f98e123905c
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://cloud.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/
```

若能正常输出以上信息，则说明安装成功。