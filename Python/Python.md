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



## 虚拟环境

虚拟环境相当于一个容器，在这个容器中安装的任何软件包都不会影响整个环境

### Python3 虚拟环境

* 环境安装: `sudo apt-get install python3-venv`

1. 创建虚拟环境 python3 -m venv myvenv（名称随意）

2. 激活虚拟环境 ./myvenv venv/bin/activate

3. 退出虚拟环境 deactivate

### Python2 虚拟环境

#### 安装

```shell
pip install virtualenv
```

#### 创建虚拟环境

```shell

virtualenv [虚拟环境的名字]
```

创建环境的时候指定Python解释器

```shell
virtualenv -p C:\Python36\python.exe [virutalenv name]
```

#### 进入环境

Linux 虚拟环境

```shell
source /path/bin/activate
```

#### 退出

```
deactivate
```



## Python 国内镜像源使用

[让PIP源使用国内镜像，提升下载速度和安装成功率。](https://www.cnblogs.com/microman/p/6107879.html)

对于Python开发用户来讲，PIP安装软件包是家常便饭。但国外的源下载速度实在太慢，浪费时间。而且经常出现下载后安装出错问题。所以把PIP安装源替换成国内镜像，可以大幅提升下载速度，还可以提高安装成功率。

### 国内源：

新版ubuntu要求使用https源，要注意。

清华：https://pypi.tuna.tsinghua.edu.cn/simple

阿里云：http://mirrors.aliyun.com/pypi/simple/

中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/

华中理工大学：http://pypi.hustunique.com/

山东理工大学：http://pypi.sdutlinux.org/ 

豆瓣：http://pypi.douban.com/simple/

### 临时使用：

可以在使用pip的时候加参数-i https://pypi.tuna.tsinghua.edu.cn/simple

例如：pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pyspider，这样就会从清华这边的镜像去安装pyspider库。


### 永久修改，一劳永逸：

Linux下，修改 ~/.pip/pip.conf (没有就创建一个文件夹及文件。文件夹要加“.”，表示是隐藏文件夹)

内容如下：

```
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host=mirrors.aliyun.com
```

windows下，直接在user目录中创建一个pip目录，如：C:\Users\xx\pip，新建文件pip.ini。内容同上。

