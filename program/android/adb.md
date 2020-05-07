# ADB 

adb速查 <https://www.wanandroid.com/blog/show/2310>

最全ADB github: <https://github.com/mzlogin/awesome-adb>

## adb 常用命令

- 查看当前连接设备：

```shell
adb devices
```

- 如果发现多个设备：

```
adb -s 设备号 其他指令
```

* 查看日志：

```
adb logcat
```

* 安装apk文件：

```
adb install xxx.apk
```

- 此安装方式，如果已经存在，无法安装；
  推荐使用**覆盖安装：**

```
adb install -r xxx.apk
```

* 卸载App:

```
adb uninstall com.zhy.app
1
```

- 如果想要保留数据，则：

```
adb uninstall -k com.zhy.app
```

- 往手机SDCard传递文件：

```
adb push 文件名 手机端SDCard路径
```

- 从手机端下载文件：

```
adb pull /sdcard/xxx.txt
```

* 查看手机端安装的所有app包名:

```
adb shell pm list packages
```

* 启动Activity:

```
adb shell am start 包名/完整Activity路径
```

* 启动服务：

```
adb shell am startservice "com.zhy.aaa/com.zhy.aaa.MyService"
```

* 屏幕截图： 

```
adb shell screencap /sdcard/screen.png
```

* 录制视频：

```  
adb shell screenrecord /sdcard/demo.mp4
```

* 清除APP数据：

```
adb shell pm clear com.example.packagename
```

* 查看所有App的名称：该命令可以查看手机上的APP名称。可以在后面加上 -f ，这样还能显示该APP的路径。
  即：

```bash
adb shell pm list packages -f
```

- 使用**adb shell input**命令向屏幕输入一些信息，

```
adb shell input text "insert%stext%shere"
```

注意：%s表示空格。

- 模拟屏幕点击事件

```
adb shell input tap 500 1450
1
```

表示在屏幕上（500，1450）的坐标点上进行一次点击。

- 模拟手势滑动事件，例如：

```
adb shell input swipe 100 500 100 1450 100
```

- 用上面的命令还可以模拟”**长按（long press）**操作，也就是2个坐标点相同，耗时超过500ms.

```java
adb shell input swipe 100 500 100 500 500
```

- 模拟点按实体按钮的命令，例如：

```
adb shell input keyevent 25
```

该命令表示调低音量。数字25是在AOSP源码中的**KeyEvent类**里定义的一个事件常量。该类定义了将近300个事件常量。

* 上面这个命令会启动浏览器打开谷歌网址页面。

```
adb shell am start -a "android.intent.action.VIEW" -d "https://www.google.com"
```

- am 也能发送广播和启动服务。比如启动一个广播，一般要添加一个**-a**：

```
adb shell am broadcast -a "our.specified.action"
```

- 使用下面的命令可以直接让手机重启：

```
adb shell am broadcast -a android.intent.action.BOOT_COMPILETED
```

- 启动一个服务也是类似，例如:

```
adb shell am startservice "com.example.crime/com.example.crime.MyService"
```

**adb shell ps**命令查看进程信息。可以在该命令后加包名，来查看某个应用程序的进程信息。

**adb shell top **命令来查看系统CPU使用情况