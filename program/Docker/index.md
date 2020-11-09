# Docker

Docker 文档: <https://www.funtl.com/zh/docs-docker/>

## 小技巧

### 查看容器日志

**方法一**
docker-compose logs --tail=10

**方法二**

docker attach apl_server

退出:

推荐使用 CTRL + p CTRL + q 方法退出, ctrl + c 会关闭容器.

### Dockerfile ADD和COPY的区别

ADD 命令对压缩文件在添加到容器的时候执行解压缩操作

COPY指令和ADD指令功能和使用方式类似。只是COPY指令不会做自动解压工作。

### 访问宿主机网络

宿主机IP: 172.17.0.1



| 标题            | 说明                                                         |
| :-------------- | :----------------------------------------------------------- |
| 镜像(Images)    | Docker 镜像是用于创建 Docker 容器的模板。                    |
| 容器(Container) | 容器是独立运行的一个或一组应用。                             |
| 客户端(Client)  | Docker 客户端通过命令行或者其他工具使用 Docker API (https://docs.docker.com/reference/api/docker_remote_api) 与 Docker 的守护进程通信。 |
| 主机(Host)      | 一个物理或者虚拟的机器用于执行 Docker 守护进程和容器。       |
| 仓库(Registry)  | Docker 仓库用来保存镜像，可以理解为代码控制中的代码仓库。Docker Hub([https://hub.docker.com](https://hub.docker.com/)) 提供了庞大的镜像集合供使用。 |
| Docker Machine  | Docker Machine是一个简化Docker安装的命令行工具，通过一个简单的命令行即可在相应的平台上安装Docker，比如VirtualBox、 Digital Ocean、Microsoft Azure。 |




