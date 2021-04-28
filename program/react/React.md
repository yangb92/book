# React

## 核心概念

### 虚拟DOM (Virtual Document Object Model)

* 本质: 在框架的概念中,程序员使用js对象模拟浏览器上的DOM和DOM嵌套关系,

* 目的: 为了实现页面中DOM元素的高效更新

### Diff 算法 (Different 差异算法)

* Tree Diff : 新旧两颗DOM树逐层对比.
* Domponent Diff:  在进行tree diff中,每一层中的组件对比, 如果类型不同进行更新
* Element Diff: 在组件进行对比的时候,如果组件组件类型相同,则需要进行元素对比

### 总结

虚拟DOM用JS模拟页面的DOM, Diff算法负责向页面更新JS模拟的DOM



## 项目实践

### 环境安装

* webpack 开发环境安装 [参考资料](webpack.md)

* 安装React组件 `cnpm i react react-dom -S`  -S 代表该模块生产需要使用, -D代表开发使用

### Hello React

index.js 只需要三步

```javascript
//1. 这两个包导入格式固定
import React from 'react' //创建组件, 虚拟DOM元素,生命周期
import ReactDOM from 'react-dom' // 把创建好的组件 和 虚拟DOM 放到页面展示

//2. 创建虚拟DOM
/*
参数1: 创建元素的类型 [字符串] 元素的名称
参数2: 是一个对象或null, 表示这个DOM元素的属性.
参数3: 子节点 (包括其他虚拟DOM)
参数n: 其他子节点

    例: <h1 id="myh1" title="这是h1"> Hello World! </h1>
*/
const myh1 = React.createElement('h1', {id:'myh1',title:'这是h1'},"Helo World!")

//3. 使用ReactDOM 把虚拟DOM渲染到页面上
/*
参数1: 要渲染的那个虚拟DOM元素
参数2: 指定页面上的一个容器 DOM对象
*/
ReactDOM.render(myh1,document.getElementById("app"))
```

index.html 中要存在一个id为app的容器

```html
<body>
    <div id="app"></div>
</body>
```

两个元素的嵌套

```js
const myh1 = React.createElement('h1', {id:'myh1',title:'这是h1'},"Helo World!")

// mydiv 嵌套 myh1
const mydiv = React.createElement('div',null,'这是一个div',myh1)
```



### 启用JSX语法

通过React.createElement方式创建虚拟DOM的方式过于麻烦, JSX是可以直接再JS中写HTML的语法

可以使用babel来将JSX语法转换成React.create Element的形式来执行.

#### babel 插件安装

##### 安装babel插件

* ` cnpm i babel-core babel-loader babel-plugin-transform-runtime -D`
* `cnpm i babel-preset-env babel-preset-stage-0 -D`

##### 安装能够识别转换jsx语法的包

* `cnpm i babel-preset-react -D`

##### 添加至webpack的module 

webpack.config.js 

```js
module: { //所有第三方模块的配置
        rules: [ //匹配规则
            {test: /\.js|jsx$/, use: 'babel-loader', exclude: /node_modules/}
        ]
    }
```

##### 在根目录添加`.babelrc`配置文件

```json
{
    "presets": ["env","stage-0","react"],
    "plugins": ["transform-runtime"]
}
```



### 语法注意事项

* jsx 中注释使用`{/*这是注释*/}`

* 元素的class属性用`className`代替
* label 的for 属性用 `hemlFor` 代替
* 数组的map迭代 `{names.map(item => <h1>{item}</h1>)}`
* key放在迭代元素上面