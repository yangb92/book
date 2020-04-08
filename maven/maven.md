# Maven

## maven 本地仓库导入jar包

```bash
mvn install:install-file -Dfile=C:\Users\DELL\Documents\mybash\uids-sm-1.0.jar -DgroupId=com.zdww -DartifactId=uids-sm -Dversion=1.0 -Dpackaging=jar
```

注意: 此脚本在powershell中执行会出现错误, 请使用git_bash或其他支持shell的终端执行