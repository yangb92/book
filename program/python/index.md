# Python

## 模拟用户操作
```py
import pyautogui as pga

pga.hotkey('winleft') # 按键
pga.typewrite(message='Teams') # 输入
pga.moveTo((428,296),duration=2) # 移动鼠标到指定位置
pga.click() # 点击
pga.hotkey('Enter') 
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

