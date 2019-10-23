# 日志

SpringBoot 使用Logback记录日志,同时也支持其他的日志实现,如Log4j2

## 控制台输出

默认为 ERROR,WARN,INFO级别信息输出日志,也可以使用 --debug 标记开启debug模式.

```bash
java -jar myapp.jar --debug
```

## 输入到文件

默认情况,SpringBoot只会将日志输出到控制台. 如果要打印到文件中, 需要设置logging.file 或者 logging.path属性.

## 日志级别

level 有 TRACE, DEBUG, INFO, WARN, ERROR, FATAL, or OFF.

下面的示例显示application.properties中的潜在日志设置

```properties
logging.level.root=WARN
logging.level.org.springframework.web=DEBUG
logging.level.org.hibernate=ERROR
```

