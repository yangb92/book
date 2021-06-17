# 数据库

## Mysql 使用root创建用户和数据库

```sh
# 从服务器登陆数据库
mysql -u root -p
use mysql;
# 创建新用户,允许外网访问
create user 'yangb'@'%' identified by '123456';
# 刷新授权
flush privileges;
# 创建数据库
create database devlop default charset utf-8mb4 collate utf8mb4_general_ci;
# 授予用户通过外网IP对于该数据库的全部权限
grant all privileges on `devlop`.* to 'yangb'@'%' identified by '123456';
# 授予用户在本地服务器对该数据库的全部权限
grant all privileges on `devlop`.* to 'yangb'@'localhost' identified by '123456';
# 刷新权限
flush privileges;
# 退书
exit
```

## Mysql 忘记root密码

```sh
# 在[mysqld]下添加skip-grant-tables，然后保存并退出
$ vi /etc/my.cnf
[mysqld]
skip-grant-tables
# 重启mysql
$ service mysqld restart
# 进入mysql
$ mysql -u root
MySQL> UPDATE mysql.user SET Password=PASSWORD('新密码') where USER='root';
MySQL> flush privileges;
MySQL> exit
# 最后把/etc/my.cnf中的skip-grant-tables注释掉，然后重启mysql
$ vi /etc/my.cnf
[mysqld]
# skip-grant-tables
$ service mysqld restart

```

## PostgresSql 数据库

管理员登陆
```
su postgres
psql
```

`\l` 查看数据库

## Oracle 数据库表数据闪回

找回删除的数据或者表

### 闪回查询
查询过去某个时间段的数据库状态

```sql
select * from  dept as of timestamp to_timestamp('2016-09-10 11:00:00','yyyy-mm-dd hh24:mi:ss');
```

### 闪回表

1. 启用表闪回首先要在表上支持行移动
2. 闪回表操作

```sql
alter table dept enable row movement;

flashback table dept to timestamp to_timestamp('2016-09-10 11:00:00','yyyy-mm-dd hh24:mi:ss');
```

闪回表可能会失败，有可能有以下几种情况：

1. 违反了数据库约束，比如用户不小心删除了子表中的数据，现在想利用闪回表技术进行回退，恰好在这中间，父表中与该数据对应的那条记录也被删除了，在这种情况下，由于违反了外键约束，导致闪回表操作失败了；
2. 撤销数据失效，比如用于支撑闪回操作的撤销数据被覆盖了，这种情况闪回表操作自然会失败；
3. 闪回不能跨越DDL，即在闪回点和当前点之间，表结构有过变更，这种情况闪回操作也会失败。

如果表和数据库被删除了，也可以闪回，请参考 
<https://www.cnblogs.com/chengxiao/p/5860823.html>