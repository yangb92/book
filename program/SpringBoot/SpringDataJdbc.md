# Spring Data Jdbc

## 添加依赖
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jdbc</artifactId>
</dependency>
```

## 创建实体
```java
@Data
@Table("t_user")
public class UserDto {
    @Id
    private String id;
    private String username;
    private String password;
    private String fullname;
    private String mobile;
}
```

## 创建Dao
```java
@Repository
public interface UserDao extends CrudRepository<UserDto,Long> {

    @Query("SELECT * FROM `t_user` where username=:username")
    UserDto findByUsername(@Param("username") String username);

}
```