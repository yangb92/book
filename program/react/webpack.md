# Webpack 简单使用

## 基本的webpack项目

* `npm init -y` 快速初始化项目目录

* 创建目录

  ```
  dist/
  src/
  	|--index.html
  	|--index.js
  ```

* 执行`cnpm i webpack webpack-cli -D` 安装webpack工具.

* 在`webpack.config.js`中配置webpack

```
module.exports = {
    mode:'development', // development, production 设置打包的格式,压缩格式和非压缩格式
}
```

* webpack 4.x 默认约定了
  * 打包的入口是 src/index.js
  * 打包的输出是 dist/main.js
* 运行 webpack 命令
* 在 index.html中引入打包好的../dist/main.js即可使用

## webpack-dev-server 的基本使用

安装 `cnpm i webpack-dev-server -D` 

* 提供默认的webpack.config.js 配置,

* 运行webpack-dev-server 日志中出现

  ```
  i ｢wds｣: Project is running at http://localhost:8080/
  i ｢wds｣: webpack output is served from /
  ```

  * 代表 webpack 打包的文件输入托管路径在当前的/根路径下,访问http://localhost:8080/main.js 可以访问到打包好的main.js
  * 但是由于webpack打包好的文件存在内存,在真实目录中并不能看得到.
  * 但我们可以在文件中引用它. /main.js 即可

* 支持其他的命令

  * --open 自动打开浏览器
  * --port 3000 端口
  * --hot 
  * --progress 
  * --compress 传输压缩
  * --host 127.0.0.1

* 例如 

  ```json
  "scripts": {
      "dev": "webpack-dev-server --open --port 3000 --host 127.0.0.1 --progress --hot"
    },
  ```

  

> 现在有个问题,我们的首页在src中,需要能够从根目录访问..

## html-webpack-plug的使用

在内存中自动生成index.html页面的插件

* 安装 `cnpm i html-webpack-plugin -D` 插件

* 插件的使用

在 webpack.config.js中加入插件

```javascript
const path = require('path')
const HtmlWebPackPlugin = require('html-webpack-plugin') //导入插件

const htmlPlugin = new HtmlWebPackPlugin({
    template: path.join(__dirname,'./src/index.html'), //源文件
    filename: 'index.html' //生成在内存中的名称
})

// 向外暴露打包的配置信息, webpack支持所有node api和语法
module.exports = {
    mode:'development', // development production
    plugins: [
        htmlPlugin
    ]
}

```

* 并且在 index.html中会自动引入main.js, 所以我们不需要再手动引入main.js了.

