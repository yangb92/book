# Spring Boot

Spring Boot 轻松创建一个独立的,工业级的Spring 应用, 可以"直接运行".

我们对Spring 平台,和第三方依赖库有着自己的见解,因此你可以减少开始的麻烦,大多数SpringBoot程序只需要很少的配置.



## @EnableAutoConfiguration

这个注解告诉SpringBoot 根据项目中添加的依赖,"猜测"你希望如何配置Spring,

## main 方法

```java
    public static void main(String[] args) {
        SpringApplication.run(Example.class, args);
    }
```

main 方法是Java程序的入口, Spring Boot 主程序执行SpringApplication的run方法启动程序, 启动Spring 等等操作, Example.class 参数是为了告诉SpringApplication 哪个是Spring的主模块, args参数是为了处理命令行的参数。

## 运行SpringBoot 项目

mvn spring-boot:run 

## 创建可执行jar文件（又称 “胖jar”）

我们需要在 pom.xml 文件中 dependencies 片段后面添加spring-boot-maven-plugin

```xml
<build>
 <plugins>
  <plugin>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-maven-plugin</artifactId>
  </plugin>
 </plugins>
</build>
```

运行`mvn package`命令，打成jar包。

如果你想查看jar的内部，使用  jar tvf target/myproject-0.0.1-SNAPSHOT.jar 命令。

使用 java -jar 命令运行jar包。

您还应该看到一个名为myproject-0.0.1- snap .jar的小得多的文件。原始文件在目标目录中。这是Maven在Spring Boot重新打包之前创建的原始jar文件

