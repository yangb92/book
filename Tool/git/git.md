# Git

## 覆盖分支
1. 把本地的devlop分支强制(-f)推送到远程master
```sh
git push origin devlop:master -f 
```
2. 用devlop覆盖当前分支
```sh
git reset –hard develop
git push origin master –f
```

## 撤销上一次commit操作

还没有push，只是在本地commit

```
git reset --soft|--mixed|--hard <commit_id>
```

--soft   保留源码,只回退到commit信息到某个版本.不涉及index的回退,如果还需要提交,直接commit即可.
--mixed    会保留源码,只是将git commit和index 信息回退到了某个版本.
--hard    源码也会回退到某个版本,commit和index 都会回退到某个版本.(注意,这种方式是改变本地代码仓库源码)
