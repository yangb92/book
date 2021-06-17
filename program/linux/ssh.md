
## 测试连接远程主机端口

``` sh
ssh -v -p 80 username@10.0.250.3
```

-v 调试模式(会打印日志).

-p 指定端口

username 可以随意

失败: ssh: connect to host 10.0.250.3 port 80: Connection refused

成功: debug: Connection established.