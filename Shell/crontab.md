# 常用指令

## crontab 定时任务

### 1. 列出定时任务

```shell
crontal -l
```

可以使用这种方法在$HOME目录中对crontab文件做一备份:

```shell
$ crontab -l > $HOME/mycron
```

### 2. 编辑crontab文件

```shell
crontab -e
```

### 3. 删除 

```shell
crontab -r
```



## 使用实例

### 实例1：每1分钟执行一次myCommand

```
* * * * * myCommand
```

### 实例2：每小时的第3和第15分钟执行

```
3,15 * * * * myCommand
```

### 实例3：在上午8点到11点的第3和第15分钟执行

```
3,15 8-11 * * * myCommand
```

### 实例4：每隔两天的上午8点到11点的第3和第15分钟执行

```
3,15 8-11 */2  *  * myCommand
```

### 实例5：每周一上午8点到11点的第3和第15分钟执行

```
3,15 8-11 * * 1 myCommand
```

### 实例6：每晚的21:30重启smb

```
30 21 * * * /etc/init.d/smb restart
```

### 实例7：每月1、10、22日的4 : 45重启smb

```
45 4 1,10,22 * * /etc/init.d/smb restart
```

### 实例8：每周六、周日的1 : 10重启smb

```
10 1 * * 6,0 /etc/init.d/smb restart
```

### 实例9：每天18 : 00至23 : 00之间每隔30分钟重启smb

```
0,30 18-23 * * * /etc/init.d/smb restart
```

### 实例10：每星期六的晚上11 : 00 pm重启smb

```
0 23 * * 6 /etc/init.d/smb restart
```

### 实例11：每一小时重启smb

```
* */1 * * * /etc/init.d/smb restart
```

### 实例12：晚上11点到早上7点之间，每隔一小时重启smb

```
0 23-7 * * * /etc/init.d/smb restart
```