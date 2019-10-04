# SQL数据库配置

传统上,“数据源”使用URL和一些凭据来建立数据库连接。

## 嵌入式数据库

使用内存内嵌入式数据库开发应用程序通常很方便,内存数据库不提供持久性存储,您需要在应用程序启动时填充数据库，并准备在应用程序结束时丢弃数据,Spring Boot可以自动配置嵌入式H2、HSQL和Derby数据库。您不需要提供任何连接url。只需要包含对要使用的嵌入式数据库的构建依赖项。

典型的POM依赖如下

```xml
<dependency>
 <groupId>org.springframework.boot</groupId>
 <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
 <groupId>org.hsqldb</groupId>
 <artifactId>hsqldb</artifactId>
 <scope>runtime</scope>
</dependency>
```

> 要自动配置嵌入式数据库，需要依赖spring-jdbc。在本例中，它通过spring-boot-starter-data-jpa被临时拉入。
>
> 无论出于什么原因，如果您确实为嵌入式数据库配置了连接URL，请确保禁用了数据库的自动关闭。如果使用H2，则应该使用DB_CLOSE_ON_EXIT=FALSE。如果使用HSQLDB，应该确保没有使用shutdown=true。禁用数据库的自动关闭允许Spring在数据库关闭时启动控制，从而确保不再需要访问数据库时启动控制。

## 连接至生产数据库

连接池选择算法:

* 我们更喜欢HikariCP的性能和并发性。如果有HikariCP，我们总是选择它
* 否则，如果Tomcat池数据源可用，我们就使用它。
* 如果HikariCP和Tomcat池数据源都不可用，如果Commons DBCP2可用，我们就使用它。

如果您使用spring-boot-starter-jdbc或spring-boot-starter-data-jpa“starter”，您将自动获得对HikariCP的依赖。

> 您可以完全绕过该算法，并通过设置spring.datasource.type 指定要使用的连接池,如果在Tomcat容器中运行应用程序，这一点尤其重要，因为默认情况下提供了Tomcat -jdbc。
>
> TIP
>
> 额外的连接池始终可以手动配置。如果定义了自己的数据源bean，则不会发生自动配置。

数据源配置由spring.datasource.*中的外部配置属性控制。例如，您可以在application.properties中声明以下部分:

```properties
spring.datasource.url=jdbc:mysql://localhost/test
spring.datasource.username=dbuser
spring.datasource.password=dbpass
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
```

> 您至少应该通过设置spring.datasource.url属性。否则，Spring Boot将尝试自动配置嵌入式数据库
>
> 通常不需要指定驱动程序类名，因为Spring Boot可以从url推断出大多数数据库的驱动程序类名。
>
> 数据源创建的时候,需要确定数据库驱动是可用的,换句话说,如果你设置了spring.datasource.driver-class-name=com.mysql.jdbc.Driver,就要确保这个类是存在的.

 DataSourceProperties 提供了连接池的更多配置属性, 除了通用的属性,还可以使用它们各自的前缀微调特定于实现的设置(spring.datasource.hikari.*, spring.datasource.tomcat.*, and spring.datasource.dbcp2.*). 

例如使用了Tomcat连接池,你需要这样定义:

```properties
# Number of ms to wait before throwing an exception if no connection is available.
spring.datasource.tomcat.max-wait=10000
# Maximum number of active connections that can be allocated from this pool at the same time.
spring.datasource.tomcat.max-active=50
# Validate the connection before borrowing it from the pool.
spring.datasource.tomcat.test-on-borrow=true
```

## 使用JdbcTemplate

JdbcTemplate 和 NamedParameterJdbcTemplate 类是自动配置的,你可以使用 @Autowire 自动导入到你的项目中

您可以使用spring.jdbc.template.*自定义模板的一些属性，如下面的例子所示

```properties
spring.jdbc.template.max-rows=500
```

## JPA 和 Spring Data JPA

Java Persistence API 是一个允许将对象“映射”到关系数据库的标准技术。spring-boot-starter-data-jpa POM提供快速开始,它提供了关键的依赖如下

* Hibernate
* Spring Data JPA:使基于jpa的存储库易于实现。
*  Spring ORMs: 来自Spring框架的核心ORM支持。

> 具体请参考Spring Data 或 Spring Data JPA

## 实体类

SpringBoot会扫描package中的实体类(用@EnableAutoConfiguration或@SpringBootApplication注释的)考虑使用@Entity、@Embeddable或@MappedSuperclass注释的任何类:

```java
package com.example.myapp.domain;
import java.io.Serializable;
import javax.persistence.*;
@Entity
public class City implements Serializable {
 @Id
 @GeneratedValue
 private Long id;
 @Column(nullable = false)
 private String name;
 @Column(nullable = false)
 private String state;
 // ... additional members, often include @OneToMany mappings
 protected City() {
  // no-args constructor required by JPA spec
  // this one is protected since it shouldn't be used directly
 }
 public City(String name, String state) {
  this.name = name;
  this.state = state;
 }
 public String getName() {
  return this.name;
 }
 public String getState() {
  return this.state;
 }
 // ... etc
}
```

您可以使用@EntityScan注释自定义实体扫描位置

## Spring Data JPA 仓库

Spring Data JPA存储库是您可以定义来访问数据的接口,JPA查询是根据您的方法名自动创建的,例如，CityRepository接口可能会声明一个findAllByState(String state) 方法来找出给定状态下的所有城市.

对于更复杂的查询，可以使用Spring Data的@Query注释对方法进行注释.

Spring数据存储库通常从存储库或CrudRepository接口扩展,如果使用自动配置，则从包含主配置类的包中搜索存储库.

下面的示例显示了一个典型的Spring数据存储库接口定义

```java
package com.example.myapp.domain;
import org.springframework.data.domain.*;
import org.springframework.data.repository.*;
public interface CityRepository extends Repository<City, Long> {
 Page<City> findAll(Pageable pageable);
 City findByNameAndStateAllIgnoringCase(String name, String state);
}
```

Spring Data JPA存储库支持三种不同的引导模式: 默认(default)延时加载(deferred) 懒加载(lazy),如果启动了延时加载和懒加载,设置  spring.data.jpa.repositories.bootstrapmode 为 deferred或lazy

> 详情请查看Spring Data JPA

### 创建和删除JAP 数据库.

默认情况下，JPA数据库只有在使用嵌入式数据库时才会自动创建 (H2, HSQL, or Derby). 您可以使用spring.jpa.*属性显式地配置JPA设置,例如，要创建和删除表，可以在application.properties中添加以下行:

```properties
spring.jpa.hibernate.ddl-auto=create-drop
```



如果您正在运行一个web应用程序，Spring Boot默认注册OpenEntityManagerInViewInterceptor来应用“Open EntityManager in View”模式,以允许在web视图中延迟加载.果不希望出现这种行为，应该将application.properties中的spring. jsp .openin-view设置为false

## Spring Data JDBC

Spring数据包含对JDBC的存储库支持，并将为CrudRepository上的方法自动生成SQL。对于更高级的查询，将提供@Query注释。

它们可以通过spring-bootstarter-data-jdbc的一个依赖项添加到您的项目中.