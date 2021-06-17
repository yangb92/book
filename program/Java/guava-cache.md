# Guava Cache

## Maven 依赖

```xml
<dependency>
   <groupId>com.google.guava</groupId>
   <artifactId>guava</artifactId>
   <version>18.0</version>
</dependency>
```

## 例子

### 延时缓存 

1. 指定缓存条目的有效期5分钟,
2. 缓存数量最多不超过1000个, 如果超出,缓存清除那些不经常使用的条目.

```java
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;

...

public static Cache<String, Object> cache = CacheBuilder
	.newBuilder()
    .expireAfterWrite(5,TimeUnit.MINUTES)
	.maximumSize(1000).build();

// 插入
cache.put(key, value);

// 获取
cache.getIfPresent(key);

// 移除
cache.invalidate(key);
...
```

