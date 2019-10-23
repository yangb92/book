# Docker

## 理解Docker:

Docker是一个供开发人员和系统管理员使用容器开发、部署和运行应用程序的平台。

### 特点:

我们使用Docker是因为它具有这些特点:

* 灵活性: 即使是最复杂的应用也可以集装箱化。
* 轻量级: 容器共享主机内核。
* 可插拔: 您可以热更新或升级(比如我们常说的灰度发布,蓝绿和金丝雀发布)
* 便携性: 您可以在本地构建、部署到云，并在任何地方运行。
* 伸缩性: 您可以方便的扩展或收缩容器集群
* 可堆叠: 您可以垂直地、动态地堆叠服务。

![Containers are portable](https://docs.docker.com/get-started/images/laurel-docker-containers.png)



### 理解 镜像(images)和容器(containers)

容器通过镜像启动, **镜像(images)**是一个包含了应用程序的所有内容(程序的代码, 运行时,库,环境变量和配置文件)的可执行包.

**容器(containers)** 是 images 运行时的实例, 根据镜像启动一个或多个实例,这个实例称为容器(containers)  



#### 容器和虚拟机区别

容器在Linux上本机运行，并与其他容器共享主机的内核。它运行一个独立的进程，不占用任何其他可执行文件的内存，使其轻量级。

相比之下，虚拟机（VM）运行一个完整的“客户”操作系统，通过虚拟机管理程序对主机资源进行虚拟访问。 通常，VM提供的环境比大多数应用程序需要的资源更多。



## 安装Docker

<https://hub.docker.com/search/?type=edition&offering=community> 选择你需要的版本.

### Windows 下安装:

版本要求: Win 10 64位专业版操作系统

硬件要求: 64位硬件, 4G 内存 ,BIOS设置中必须启用BIOS级硬件虚拟化支持。

选择windows版本docker版本下载, 按照提示安装即可.

后续再补



设置存储库:

```bash
$ sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

安装:

```bash
sudo yum install docker-ce docker-ce-cli containerd.io
```



## 使用 Docker

### 创建镜像(Images)

后续再补

### 运行容器Container

后续再补

### 服务 

在分布式环境中, 生产中的容器一个服务只需要一个Images, 它规范了服务的端口, 副本的数量, 服务的容量等等,.使用Docker平台很容易定义、运行和扩展服务——只需编写一个docker-composition.yml文件。

`docker-compose.yml` 文件

```yaml
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: username/repo:tag
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "4000:80"
    networks:
      - webnet
networks:
  webnet:
```



集群