# 定制 Security 上下文存储

## 使用Redis管理会话

### Docker Redis安装

在目录`/usr/local/docker/redis`创建docker-compose.yml配置文件

`docker-compose.yml`
```yml
version: '3'

services:
  redis:
    image: redis:5
    container_name: redis
    restart: always
    ports:
      - '6379:6379'
    volumes:
      - ./data:/data
```

运行
```sh
docker-compose up -d
```

### 加入Redis依赖
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

### `application.yml`配置文件
```
spring:
  redis:
    host: 192.168.10.45
    timeout: 3000
```

### 配置`RedisConfig.java`配置文件

```java

/**
 * Created by yangb on 2020/4/17
 */
@Configuration
public class RedisConfig {

    @Bean
    public RedisTemplate<String, SecurityContext> securityContextRedisTemplate(RedisConnectionFactory redisConnectionFactory) {
        RedisTemplate template = new RedisTemplate();
        template.setConnectionFactory(redisConnectionFactory);
        template.setValueSerializer(new SecurityContextSerializer());
        return template;
    }

    /**
     * SecurityContext 序列化
     */
    private class SecurityContextSerializer implements RedisSerializer<SecurityContext>{

        @Override
        public byte[] serialize(SecurityContext securityContext) throws SerializationException {
            if (securityContext == null) {
                return null;
            }
            String s = JSON.toJSONString(securityContext);
            return s.getBytes(Charset.forName("UTF-8"));
        }

        @Override
        public SecurityContext deserialize(byte[] bytes) throws SerializationException {
            SecurityContextImpl securityContext = new SecurityContextImpl();
            if (bytes == null) {
                return securityContext;
            }
            String json = new String(bytes, Charset.forName("UTF-8"));
            final JSONObject jb = JSON.parseObject(json);
            JSONObject authentication = jb.getJSONObject("authentication");
            if(authentication == null) {
                return securityContext;
            }
            AppUser user = authentication.getObject("principal", AppUser.class);
            JSONArray authorities = authentication.getJSONArray("authorities");
            String [] authoritiesArray = new String[authorities.size()];
            for (int i = 0; i < authorities.size(); i++) {
                JSONObject authority = authorities.getJSONObject(i);
                authoritiesArray[i] = authority.getString("authority");
            }
            securityContext.setAuthentication(new UsernamePasswordAuthenticationToken(user, null, AuthorityUtils.createAuthorityList(authoritiesArray)));
            return securityContext;
        }
    }
}

```

### 配置`RedisSecurityContextRepository.java`上下文仓库
```java
/**
 * Created by yangb on 2020/4/17
 */
@Component
public class RedisSecurityContextRepository implements SecurityContextRepository {

    @Resource
    private RedisTemplate<String, SecurityContext> securityContextRedisTemplate;

    @Override
    public SecurityContext loadContext(HttpRequestResponseHolder requestResponseHolder) {
        String requestedSessionId = requestResponseHolder.getRequest().getRequestedSessionId();
        return securityContextRedisTemplate.opsForValue().get(requestedSessionId);
    }

    @Override
    public void saveContext(SecurityContext context, HttpServletRequest request, HttpServletResponse response) {
        String requestedSessionId = request.getRequestedSessionId();
        securityContextRedisTemplate.opsForValue().set(requestedSessionId,context,30, TimeUnit.MINUTES);
    }

    @Override
    public boolean containsContext(HttpServletRequest request) {
        return securityContextRedisTemplate.hasKey(request.getRequestedSessionId());
    }

    /**
     * 清除Redis上下文
     */
    public boolean cleanContext(HttpServletRequest request){
        return securityContextRedisTemplate.delete(request.getRequestedSessionId());
    }
}
```

### 配置上下文仓库 和 退出时执行清除Redis中上下环境,
```java
@Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .securityContext()
                .securityContextRepository(redisSecurityContextRepository);
            .logout()
                .logoutSuccessHandler((request, response, authentication) -> {
                    redisSecurityContextRepository.cleanContext(request); //清除缓存会话
                })
                ...
```