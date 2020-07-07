# WebSocket

## 服务端

Spring Boot

### pom.xml
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <!-- 这个玩意是重点 -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-websocket</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <scope>runtime</scope>
        <optional>true</optional>
    </dependency>
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
    <dependency>
        <groupId>cn.hutool</groupId>
        <artifactId>hutool-all</artifactId>
        <version>5.3.7</version>
    </dependency>
</dependencies>
```

### 启动类

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;

@SpringBootApplication
public class ServerApplication {

    public static void main(String[] args) {
        SpringApplication.run(ServerApplication.class, args);
    }

    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }
}
```

### 实体类
```java
@Data
public class Message {
    private String from;
    private String to;
    private String message;
}
```

### WebSocket类
```java
@ServerEndpoint("/imserver/{user}")
@Slf4j
@Component
public class ImServer {

    private static ConcurrentHashMap<String, Session> sessionMap = new ConcurrentHashMap<>();

    private String user;

    @OnOpen
    public void open(Session session,@PathParam("user") String user){
        log.info(user+"已连接");
        sessionMap.put(user, session);
        this.user = user;
    }

    @OnClose
    public void close(){
       log.info(user + "退出聊天室！");
    }

    @OnMessage
    public void message(String message, Session session){
        log.info(message);
        if(StrUtil.isNotBlank(message)){
            Message msg = new Message();
            msg.setMessage(message);
            msg.setFrom(user);
            msg.setTo("all");
            sendAll(msg);
        }
    }

    @OnError
    public void onError(Session session, Throwable error) {
        log.error("用户错误:"+this.user+",原因:"+error.getMessage());
        error.printStackTrace();
    }
    /**
     * 群发消息
     */
    public static void sendAll(Message message){
        sessionMap.values().forEach(session -> {
            if(session.isOpen()){
                session.getAsyncRemote().sendText(JSONUtil.toJsonStr(message));
            }
        });
    }
}
```

## 客户端
```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebSocket</title>
    <style>
        .show {display: inline;}
        .hiden {display: none;}
        #talk {width: 500px;height: 200px;}
        #receive,#send {width: 100%;height: 100%;}
        #talk>button {width: 100%;}
    </style>
</head>

<body>
    <div class="user">
        <input type="text" name="您的昵称" id="user" placeholder="请输入昵称">
        <button onclick="openSocket()" id='accept'>开始聊天</button>
    </div>
    <div id='talk' class="hiden">
        <textarea id="receive" cols="30" rows="10"></textarea>
        <hr />
        <textarea id="send" cols="30" rows="10"></textarea>
        <button onclick="sendMsg()">发送</button>
    </div>
</body>
<script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.js"></script>
<script>
    var socket;
    function openSocket() {
        var url = "ws://localhost:8080/imserver/" + $('#user').val()
        socket = new WebSocket(url)
        //打开链接事件
        socket.onopen = function () {
            console.log('聊天室已连接')
            $('#accept').attr('disabled', true);
            $('#talk').attr('class', 'show');
        }
        //获得消息事件
        socket.onmessage = function (msg) {
            console.log(msg)
            data = JSON.parse(msg.data)
            $('#receive').append(data.from + "说：" + data.message + "\n");
        }
        //关闭事件
        socket.onclose = function () {
            console.log("websocket已关闭");
        };
        //发生了错误事件
        socket.onerror = function () {
            console.log("websocket发生了错误");
        }
    }
    //发送消息
    function sendMsg() {
        socket.send($('#send').val())
        $('#send').val('');
    }
</script>

</html>
```