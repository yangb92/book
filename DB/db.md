# 数据库

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