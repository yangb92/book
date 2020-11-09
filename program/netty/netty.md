# Netty

https://netty.io

Netty is an asynchronous event-driven network application framework
for rapid development of maintainable high performance protocol servers & clients.

![img](https://netty.io/images/components.png)

**NIO 存在的问题**

1. NIO 类库和API 复杂, 使用麻烦.
2. 需要熟悉Java多线程编程和网格编程.
3. 工作量和难度大: 例如面临客户端断链重连, 网络闪包, 半包读写.缓存失败等等
4. JDK中NIO的Bug, 例如Epoll Bug 导致 Selector 空轮询, 该问题没有被从根本解决.

**Netty 优点**

开发效率高, 文档齐全, 功能全面。对 JDK 自带的 NIO 的 API 进行了封装。解决了 NIO 存在的问题。

## 安装

2020-jul-9 最新版本：4.1.51.Final

依赖包下载：https://netty.io/downloads.html

Maven： 

```xml
<dependencies>
  ...
  <dependency>
    <groupId>io.netty</groupId>
    <artifactId>netty</artifactId> <!-- Use 'netty-all' for 4.0 or above -->
    <version>X.Y.Z.Q</version>
    <scope>compile</scope>
  </dependency>
  ...
</dependencies>
```

