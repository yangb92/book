# Spring Boot 打 war 包

修改`pom.xml`

```xml
<packaging>war</packaging>
...
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <!-- 打包部署到tomcat上面时，不需要打包tmocat相关的jar包，否则会引起jar包冲突 -->
    <exclusions>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
        </exclusion>
    </exclusions>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-tomcat</artifactId>
    <scope>provided</scope>
</dependency>
...
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

修改启动类

```java
@SpringBootApplication
public class BlogApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(BlogApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(BlogApplication.class);
    }
}
```

使用maven打包

```bash
mvn clean package -Dmaven.test.skip=true
```