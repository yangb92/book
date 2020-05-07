
# 依赖管理requirement.txt 

## 生成依赖目录

### 使用`freeze`生成requirement.txt

生成python环境的依赖

```python
pip freeze > requirements.txt
```

### 利用pipreqs生成requirement.txt

生成当前工程的依赖

安装
```bash
pip install pipreqs
```
运行
```bash
pipreqs ./
```
报错
```
 File "c:\users\devtao\appdata\local\programs\python\python36-32\lib\site-packages\pipreqs\pipreqs.py", line 341, in init
    extra_ignore_dirs=extra_ignore_dirs)
  File "c:\users\devtao\appdata\local\programs\python\python36-32\lib\site-packages\pipreqs\pipreqs.py", line 75, in get_all_imports
    contents = f.read()
UnicodeDecodeError: 'gbk' codec can't decode byte 0xa6 in position 186: illegal multibyte sequence
```
直接pipreqs.py 的75行，将encoding改为utf-8

## 安装requirements.txt依赖

```python
pip install -r requirements.txt
```