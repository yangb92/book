# Hexo 博客搭建

博客的基础搭建请参考: [官方文档](<https://hexo.io/zh-cn/docs/index.html>)



## 推荐主题

主题: <https://github.com/jerryc127/hexo-theme-butterfly> 

主题预览: <https://jerryc.me/>

主题安装文档:<https://jerryc.me/posts/21cfbf15>

博客扩展设置: <https://jerryc.me/posts/31391d01>



## 为博客添加宠物

详细资料: <https://github.com/EYHN/hexo-helper-live2d>

宠物包: <https://github.com/xiazeyu/live2d-widget-models>



```
npm install --save hexo-helper-live2d
```

在站點配置文件或者主題配置文件添加以下内容

```yml
live2d:
  enable: true
  scriptFrom: local
  pluginRootPath: live2dw/
  pluginJsPath: lib/
  pluginModelPath: assets/
  model:
    use: live2d-widget-model-wanko # 宠物的模型
  display:
    position: right
    width: 150
    height: 300
  mobile:
    show: true
```



安裝需要的寵物文件:

```
npm install {packagename}
```







