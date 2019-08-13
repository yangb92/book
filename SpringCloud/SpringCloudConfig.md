# Spring Cloud Config

Spring Cloud Config 为分布式系统中的外部化配置,  提供了服务端和客户端支持, 使用Config Server, 你有一个中心位置管理应用程序中的外部属性,客户端和服务端上的映射与Spring Environment和PropertySource抽象相同.因此他们非常适合Spring的应用程序,但也能够使用到其他任何程序和任何语言, 当应用程序从部署流程从开发到测试并进入生产时,你可以管理这些环境之间的配置并且确保应用程序在迁移时拥有所需要的一切.服务端后端存储默认实现用的是git,因此它可以很容易的支持配置环境的标签版本,以及可用于管理内容的各种工具,可以很容易的替代实现,并使用Spring配置插入.

## Spring Cloud Config Server

参考文件:<https://cloud.spring.io/spring-cloud-static/Greenwich.SR2/multi/multi__spring_cloud_config_server.html>

Spring Coloud Config Server 为外部配置提供了基于Http 资源的API, 可嵌入到Spring Boot 项目中, 使用`@EnableConfigServer` 注解,因此,下面的程序是一个配置服务程序:

```java
@SpringBootApplication
@EnableConfigServer
public class ConfigServer {
  public static void main(String[] args) {
    SpringApplication.run(ConfigServer.class, args);
  }
}
```

和所有的SpringBoot程序一样,它默认运行在8080端口,你可以通过各种方式切换到惯用的8888端口,它还设置了默认的配置库, 通过spring.config.name=configserver 启动它(配置服务的jar包中有一个configserver.yml文件),另一种方法使用自己的applicationg.properties文件,如下所示:

application.properties

```properties
server.port: 8888
spring.cloud.config.server.git.uri: file://${user.home}/config-repo
```

${user.home}/config-repo 是一个git存储库,包含了YAML和properties文件,

> 在windows,在绝对路径的URL前缀,需要额外的 "/" 例如file:///${user.home}/config-repo
>
> 创建Git存储卡的方法
>
> ```shell
> $ cd $HOME
> $ mkdir config-repo
> $ cd config-repo
> $ git init .
> $ echo info.foo: bar > application.properties
> $ git add -A .
> $ git commit -m "Add application.properties"
> ```
>
> 在本地使用Git存储库仅用来测试,应该使用服务器在生产环境中配置存储库.

## 环境存储库

配置服务的配置数据应该存到哪里,管理此行为的策略是 EnvironmentRepository 服务 Environment对象,这个Environment是Spring 环境的对象的浅拷贝(包括PropertySource的主要特性),环境的资源有三个参数的变化.

- `{application}`, 映射到客户端 `spring.application.name` 
- `{profile}`,映射到客户端 `spring.profiles.active` (以逗号分隔的List).
- `{label}` 这是标记版本的服务端功能

下面是一个客户端程序的引导配置文件:

**bootstrap.yml**

```yaml
spring:
  application:
    name: foo
  profiles:
    active: dev,mysql
```

和Spring boot 的程序一样,这些参数也能够通过环境变量或命令行参数设置

如果存储库是基于文件的, 配置服务将根据application.yml和foo.yml(foo.yml 优先)创建一个Environment(在所有客户端共享)

### GIT 后端

`EnvironmentRepository`  的实现默认是Git后端,这对于管理升级和物理环境以及审计更改非常方便. 修改仓库的位置,你可以在配置服务中设置 spring.cloud.config.server.git.uri 属性(例如在 application.yml),如果你设置的是 file: 前缀,将会在本地存储库中工作,这样您就可以在没有服务器的情况下快速轻松的开始工作.然而,在这种情况下, 服务直接在本地存储库上运行而不进行克隆. Config Server 永远不会对远程存储库进行更改.

存储库实现将HTTP资源的{label}参数映射到一个git标签(commit id, 分支名称,或标签)如果git的分支或标签名称包含斜杠/, 然后应该使用特殊字符串（_）指定HTTP URL中的标签（以避免与其他URL路径不一致）例如 foo/bar 要转成foo(\_)bar,也可应用于 {application}的参数,

#### 跳过SSL验证

关闭配置服务器校验GIT服务的SSL证书,设置`git.skipSslValidation` 属性为`true`, 默认为false

```yaml
spring:
  cloud:
    config:
      server:
        git:
          uri: https://example.com/my/repo
          skipSslValidation: true
```

#### 设置HTTP连接超时时间

可以设置一个超时时间,单位是秒,使用git.timeout 属性

```yaml
spring:
  cloud:
    config:
      server:
        git:
          uri: https://example.com/my/repo
          timeout: 4
```

#### Git URL 占位符

Spring Cloud Config Server 支持git存储库的URL占位符 `{application}` and `{profile}` (and `{label}`  如果你需要使用lable ,但是请记住,这个标签是作为git标签应用的),因此，您可以使用类似于以下的结构来支持“每个应用程序一个存储库”策略：

```yaml
spring:
  cloud:
    config:
      server:
        git:
          uri: https://github.com/myorg/{application}
```

你也可以使用,一个仓库一个配置文件方式,使用类似的模式,使用{profile}



#### 模糊匹配和多个存储库

Spring Cloud Config 还支持对应用程序和配置文件的名称进行模糊匹配更复杂的需求.该模式格式是带有通配符的{application} / {profile}名称的逗号分隔列表,如下所示

```yaml
spring:
  cloud:
    config:
      server:
        git:
          uri: https://github.com/spring-cloud-samples/config-repo
          repos:
            simple: https://github.com/simple/config-repo
            special:
              pattern: special*/dev*,*special*/dev*
              uri: https://github.com/special/config-repo
            local:
              pattern: local*
              uri: file:/home/configsvc/config-repo
```

如果都不匹配,则使用默认uri定义spring.cloud.config.server.git.uri, 上述的例子所示simple仓库匹配simple/*, 它只匹配应用程序名称以simple开头的应用程序,本地存储库匹配所有配置文件中以local开头的所有应用程序名称.

> 只有当要设置的唯一属性是URI时，才可以使用简单示例中使用的单行捷径。如果需要设置其他内容(凭证、模式等)，则需要使用完整的表单。

repo中的`pattern`属性实际上是一个数组，因此您可以使用属性文件中的YAML数组（或`[0]`，`[1]`等后缀）绑定到多个模式。如果要运行具有多个配置文件的应用程序，则可能需要执行此操作。例：

```yaml
spring:
  cloud:
    config:
      server:
        git:
          uri: https://github.com/spring-cloud-samples/config-repo
          repos:
            development:
              pattern:
                - */development
                - */staging
              uri: https://github.com/development/config-repo
            staging:
              pattern:
                - */qa
                - */production
              uri: https://github.com/staging/config-repo
```



### 文件系统后端

--略 请参考 <https://cloud.spring.io/spring-cloud-static/Greenwich.SR2/multi/multi_spring-cloud.html>  