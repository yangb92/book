# GitLab Runner linux 系统安装

添加依赖库
```sh
 # For Debian/Ubuntu/Mint
 curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash

 # For RHEL/CentOS/Fedora
 curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
```

安装
```sh
# MacOS
sudo brew install gitlab-ci-multi-runner

# For Debian/Ubuntu/Mint

sudo apt-get install gitlab-ci-multi-runner

# For RHEL/CentOS/Fedora
sudo yum install gitlab-ci-multi-runner
```

## 常见问题:

GitRunner 执行Docker 命令启动Permission Denied,需要将gitlab-runner加入`Docker`组

```sh
gpasswd -a gitlab-runner docker
newgrp docker
```



# GitLab Runner Docker安装

使用GitLab CI 运行构建任务会影响GitLab性能.
GitLab CI最大的作用是管理项目的构建状态,因此构建任务由GitLab Runner(GitLab 高级技能)来做.

## 环境准备

* 创建工作目录: `/usr/local/docker/runner`
* 创建构建目录: `/usr/local/runner/evironment`
* 下载`jdk-8u152-linux-x64.tar.gz`并复制到`/usr/local/runner/evironment`
* 下载`apache-maven-3.5.3-bin.tar.gz`并复制到`/usr/local/docker/runner/environment`

### daemon.json

在 `/usr/local/docker/runner/environment` 目录下创建 `daemon.json`，用于配置加速器和仓库地址
```json
{
  "registry-mirrors": [
    "https://registry.docker-cn.com"
  ],
  "insecure-registries": [
    "192.168.10.133:5000"
  ]
}
```

### Dockerfile

在 /usr/local/docker/runner/environment 目录下创建 Dockerfile

```sh
FROM gitlab/gitlab-runner
MAINTAINER Lusifer <topsale@vip.qq.com>

# 修改软件源
RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse' > /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse' >> /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get clean

# 安装 Docker
RUN apt-get -y install apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update -y && \
    apt-get install -y docker-ce
COPY daemon.json /etc/docker/daemon.json

# 安装 Docker Compose
WORKDIR /usr/local/bin
RUN wget https://raw.githubusercontent.com/topsale/resources/master/docker/docker-compose
RUN chmod +x docker-compose

# 安装 Java
RUN mkdir -p /usr/local/java
WORKDIR /usr/local/java
COPY jdk-8u152-linux-x64.tar.gz /usr/local/java
RUN tar -zxvf jdk-8u152-linux-x64.tar.gz && \
    rm -fr jdk-8u152-linux-x64.tar.gz

# 安装 Maven
RUN mkdir -p /usr/local/maven
WORKDIR /usr/local/maven
# RUN wget https://raw.githubusercontent.com/topsale/resources/master/maven/apache-maven-3.5.3-bin.tar.gz
COPY apache-maven-3.5.3-bin.tar.gz /usr/local/maven
RUN tar -zxvf apache-maven-3.5.3-bin.tar.gz && \
    rm -fr apache-maven-3.5.3-bin.tar.gz
# COPY settings.xml /usr/local/maven/apache-maven-3.5.3/conf/settings.xml

# 配置环境变量
ENV JAVA_HOME /usr/local/java/jdk1.8.0_152
ENV MAVEN_HOME /usr/local/maven/apache-maven-3.5.3
ENV PATH $PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin

WORKDIR /

```

### docker-compose.yml

在 /usr/local/docker/runner 目录下创建 docker-compose.yml

```yml
version: '3.1'
services:
  gitlab-runner:
    build: environment
    restart: always
    container_name: gitlab-runner
    privileged: true
    volumes:
      - ./config:/etc/gitlab-runner
      - /var/run/docker.sock:/var/run/docker.sock
```

```yml
version: '3.1'

services:
  gs-wsbs:
    image: gs-wsbs
    restart: always
    container_name: gs-wsbsdt
    privileged: true
    ports:
      - '8090:8080'
```

### 注册 Runner

```sh
docker exec -it gitlab-runner gitlab-runner register

# 输入 GitLab 地址
Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://192.168.10.132/

# 输入 GitLab Token
Please enter the gitlab-ci token for this runner:
1Lxq_f1NRfCfeNbE5WRh

# 输入 Runner 的说明
Please enter the gitlab-ci description for this runner:
可以为空

# 设置 Tag，可以用于指定在构建规定的 tag 时触发 ci
Please enter the gitlab-ci tags for this runner (comma separated):
deploy

# 这里选择 true ，可以用于代码上传后直接执行
Whether to run untagged builds [true/false]:
true

# 这里选择 false，可以直接回车，默认为 false
Whether to lock Runner to current project [true/false]:
false

# 选择 runner 执行器，这里我们选择的是 shell
Please enter the executor: virtualbox, docker+machine, parallels, shell, ssh, docker-ssh+machine, kubernetes, docker, docker-ssh:
shell

```

## 使用Runner

### GitLab CI 地址与令牌参数

`项目` –> `设置` –> `CI/CD` –> `Runner 设置`

## .gitlab-ci.yml

在项目工程下编写`.gitlab-ci.yml`配置文件：

```yml
stages:
  - build
  - run
  - clean

build:
  stage: build
  only:
    - v5
  script:
    - mvn clean package -Dmaven.test.skip=true
    - mv ygzw_wsbsdt_front/target/ygzw_wsbsdt_front.war docker/ROOT.war
    - cd docker
    - docker build -t gs-wsbs .

run:
  stage: run
  only:
    - v5
  script:
    - cd docker
    - docker-compose down
    - docker-compose up -d

clean:
  stage: clean
  only:
    - v5
  script:
    - docker rmi $(docker images -q -f dangling=true)
```

上面的配置把一次 Pipeline 分成五个阶段：

- 安装依赖(install_deps)
- 运行测试(test)
- 编译(build)
- 部署测试服务器(deploy_test)
- 部署生产服务器(deploy_production)

**注意：** 设置 Job.only 后，只有当 develop 分支和 master 分支有提交的时候才会触发相关的 Jobs。

节点说明：

- stages：定义构建阶段，这里只有一个阶段 deploy
- deploy：构建阶段 deploy 的详细配置也就是任务配置
- script：需要执行的 shell 脚本
- only：这里的 master 指在提交到 master 时执行
- tags：与注册 runner 时的 tag 匹配



### 其它命令

- 删除注册信息

```text
gitlab-ci-multi-runner unregister --name "名称"
```

- 查看注册列表

```text
gitlab-ci-multi-runner list
```



## 附：项目配置 Dockerfile 案例

```dockerfile
FROM tomcat:8
MAINTAINER yangb http://yangb.xyz
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war
```

```dockerfile
FROM openjdk:8-jre
MAINTAINER Lusifer <topsale@vip.qq.com>

ENV APP_VERSION 1.0.0-SNAPSHOT
ENV DOCKERIZE_VERSION v0.6.1 # 检测其他服务的插件
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mkdir /app

COPY myshop-service-user-provider-$APP_VERSION.jar /app/app.jar
ENTRYPOINT ["dockerize", "-timeout", "5m", "-wait", "tcp://192.168.10.131:3306", "java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.jar"]

EXPOSE 8501
```