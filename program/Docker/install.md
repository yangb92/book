
# Docker安装

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

## Docker 仓库

公共仓库: https://hub.docker.com