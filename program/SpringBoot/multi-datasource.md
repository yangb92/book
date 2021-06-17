# SpringBoot 多数据源项目

pom.xml

```xml
<!-- 主要依赖 -->
<dependencies>
    <!--数据源-->
    <dependency>
        <groupId>com.oracle</groupId>
        <artifactId>ojdbc6</artifactId>
        <version>11.2.0.3</version>
    </dependency>
    <dependency>
        <groupId>tk.mybatis</groupId>
        <artifactId>mapper-spring-boot-starter</artifactId>
        <version>2.0.2</version>
    </dependency>
    <dependency>
        <groupId>com.github.pagehelper</groupId>
        <artifactId>pagehelper-spring-boot-starter</artifactId>
        <version>1.2.5</version>
    </dependency>
</dependencies>

```

application.yml

```yml
# 网上办事数据库配置
wsbs:
  datasource:
    driver-class-name: oracle.jdbc.driver.OracleDriver
    url: jdbc:oracle:thin:@47.98.63.50:1521:ORCL
    username: APL_YGZW_POWER
    password: APL_YGZW_POWER
    mapper-location: classpath:mapper/wsbs/*.xml

# 政务网数据库配置
zww:
  datasource:
    driver-class-name: oracle.jdbc.driver.OracleDriver
    url: jdbc:oracle:thin:@47.98.63.50:1521:ORCL
    username: APL_YGZW_ONLINE
    password: APL_YGZW_ONLINE
    mapper-location: classpath:mapper/zww/*.xml
```

启动类

```java
// 关闭默认的数据源配置
@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)
public class YgzwDataExchangeApplication {

    public static void main(String[] args) {
        SpringApplication.run(YgzwDataExchangeApplication.class, args);
    }
}
```

配置类
```java
/**
 * 多数据源配置
 * Created by YangBin on 2020/7/21
 * Copyright (c) 2020 杨斌 All rights reserved.
 */
@Configuration
public class DataSourceConfig {

    @Data
    @Configuration
    @ConfigurationProperties("wsbs.datasource")
    @MapperScan(basePackages = "com.zjapl.ygzw.data.exchange.wsbs.dao", sqlSessionFactoryRef = "wsbsSqlSessionFactory")
    class WsbsDataSource{
        private String driverClassName;

        private String url;

        private String username;

        private String password;

        private String mapperLocation;

        @Bean(name = "wsbsSqlSessionFactory")
        public SqlSessionFactory wsbsSqlSessionFactory() throws Exception {
           return buildSqlSessionFactory(this.driverClassName,this.url,this.username,this.password,this.mapperLocation);
        }
    }

    @Data
    @Configuration
    @ConfigurationProperties("zww.datasource")
    @MapperScan(basePackages = "com.zjapl.ygzw.data.exchange.zww.dao", sqlSessionFactoryRef = "zwwSqlSessionFactory")
    public class ZwwDataSourceConfig {

        private String driverClassName;

        private String url;

        private String username;

        private String password;

        private String mapperLocation;

        @Bean(name = "zwwSqlSessionFactory")
        public SqlSessionFactory zwwSqlSessionFactory() throws Exception {
            return buildSqlSessionFactory(this.driverClassName,this.url,this.username,this.password,this.mapperLocation);
        }
    }

   public SqlSessionFactory buildSqlSessionFactory(String driverClassName,String url,String username,String password,String mapperLocation) throws Exception {
        DataSourceProperties dataSourceProperties = new DataSourceProperties();
        dataSourceProperties.setDriverClassName(driverClassName);
        dataSourceProperties.setUsername(username);
        dataSourceProperties.setPassword(password);
        dataSourceProperties.setUrl(url);
        HikariDataSource datasource = dataSourceProperties.initializeDataSourceBuilder().type(HikariDataSource.class).build();
        SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
        factoryBean.setDataSource(datasource);
        factoryBean.setMapperLocations(new PathMatchingResourcePatternResolver()
                .getResources(mapperLocation));
        return factoryBean.getObject();
    }    

}
```