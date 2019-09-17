# Python

## 依赖管理requirement 

### 生成当前项目的requirement.txt

```python
pip freeze > requirements.txt
```

### 安装requirements.txt依赖

```python
pip install -r requirements.txt
```



## 虚拟环境 - virtualenv

虚拟环境相当于一个容器，在这个容器中安装的任何软件包都不会影响整个环境

### 安装

```shell
pip install virtualenv
```

### 创建虚拟环境

```shell

virtualenv [虚拟环境的名字]
```

创建环境的时候指定Python解释器

```shell
virtualenv -p C:\Python36\python.exe [virutalenv name]
```

### 进入环境

Linux 虚拟环境

```shell
source /path/bin/activate
```

### 退出

```
deactivate
```

