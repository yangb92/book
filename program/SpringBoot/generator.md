# Mybatis Maven插件生成代码

# 配置插件

在`pom.xml`文件中增加`mybatis-generator-maven-plugin`插件

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.mybatis.generator</groupId>
            <artifactId>mybatis-generator-maven-plugin</artifactId>
            <version>1.3.5</version>
            <configuration>
                <configurationFile>${basedir}/src/main/resources/generator/generatorConfig.xml</configurationFile>
                <overwrite>true</overwrite>
                <verbose>true</verbose>
            </configuration>
            <dependencies>
                <dependency>
                    <groupId>mysql</groupId>
                    <artifactId>mysql-connector-java</artifactId>
                    <version>${mysql.version}</version>
                </dependency>
                <dependency>
                    <groupId>tk.mybatis</groupId>
                    <artifactId>mapper</artifactId>
                    <version>3.4.4</version>
                </dependency>
            </dependencies>
        </plugin>
    </plugins>
</build>
```
configurationFile：自动生成所需的配置文件路径

## 自动生成的配置

在 src/main/resources/generator/ 目录下创建 generatorConfig.xml 配置文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>
    <!-- 引入数据库连接配置 -->
    <properties resource="generator/jdbc.properties"/>

    <context id="Mysql" targetRuntime="MyBatis3Simple" defaultModelType="flat">
        <property name="beginningDelimiter" value="`"/>
        <property name="endingDelimiter" value="`"/>

        <!-- 配置 tk.mybatis 插件 -->
        <plugin type="tk.mybatis.mapper.generator.MapperPlugin">
            <property name="mappers" value="tk.mapper.Dao"/>
        </plugin>

        <!-- 配置数据库连接 -->
        <jdbcConnection
                driverClass="${jdbc.driverClass}"
                connectionURL="${jdbc.connectionURL}"
                userId="${jdbc.username}"
                password="${jdbc.password}">
            <property name="nullCatalogMeansCurrent" value="true"/>
        </jdbcConnection>

        <!-- 配置实体类存放路径 -->
        <javaModelGenerator targetPackage="com.yangb.project.quickdev.entity" targetProject="src/main/java"/>

        <!-- 配置 XML 存放路径 -->
        <sqlMapGenerator targetPackage="mapper" targetProject="src/main/resources"/>

        <!-- 配置 DAO 存放路径 -->
        <javaClientGenerator
                targetPackage="com.yangb.project.quickdev.dao"
                targetProject="src/main/java"
                type="XMLMAPPER"/>

        <!-- 配置需要指定生成的数据库和表，% 代表所有表 -->
        <table tableName="%">
            <!-- mysql 配置 -->
            <generatedKey column="id" sqlStatement="Mysql" identity="true"/>
        </table>
    </context>
</generatorConfiguration>
```

## 配置数据源

在 src/main/resources/generator 目录下创建 jdbc.properties 数据源配置：

```properties
# MySQL 8.x: com.mysql.cj.jdbc.Driver
jdbc.driverClass=com.mysql.jdbc.Driver
jdbc.connectionURL=jdbc:mysql://ip:port/dbname?useUnicode=true&characterEncoding=utf-8&useSSL=false
jdbc.username=root
jdbc.password=123456
```

## 插件自动生成命令

```
mvn mybatis-generator:generate
```
