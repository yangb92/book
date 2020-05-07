# 版本选型

Spring Boot 版本选型:  19年以后不再使用 1.5 版本, 一定要使用2.x版本

Spring Cloud 版本选型: H版 采用伦敦地铁站来命名. Hoxton.SR3

## Spring Boot 和 Spring Cloud 版本匹配对应

| Release Train | Boot Version |
| :------------ | :----------- |
| Hoxton        | 2.2.x        |
| Greenwich     | 2.1.x        |
| Finchley      | 2.0.x        |
| Edgware       | 1.5.x        |
| Dalston       | 1.5.x        |

查看版本匹配关系

https://start.spring.io/actuator/info

```text
"Hoxton.SR3":"Spring Boot >=2.2.0.M4 and <2.3.0.BUILD-SNAPSHOT"
```

或者在Spring官网[Spring Cloud](https://spring.io/projects/spring-cloud#learn) Reference Doc点进去可以看到,推荐的匹配版本

```
Release Train Version: Hoxton.SR3

Supported Boot Version: 2.2.5.RELEASE
```

## Spring Cloud 和 Spring Cloud Alibaba版本对应关系

[https://github.com/alibaba/spring-cloud-alibaba/wiki/%E7%89%88%E6%9C%AC%E8%AF%B4%E6%98%8E](https://github.com/alibaba/spring-cloud-alibaba/wiki/版本说明)

| Spring Cloud Version        | Spring Cloud Alibaba Version | Spring Boot Version |
| --------------------------- | ---------------------------- | ------------------- |
| Spring Cloud Hoxton.SR3     | 2.2.1.RELEASE                | 2.2.5.RELEASE       |
| Spring Cloud Hoxton.RELEASE | 2.2.0.RELEASE                | 2.2.X.RELEASE       |
| Spring Cloud Greenwich      | 2.1.2.RELEASE                | 2.1.X.RELEASE       |
| Spring Cloud Finchley       | 2.0.2.RELEASE                | 2.0.X.RELEASE       |
| Spring Cloud Edgware        | 1.5.1.RELEASE                | 1.5.X.RELEASE       |