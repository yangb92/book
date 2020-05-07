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

