# UI 框架

## vant UI 组件库

vant :移动端UI组件库,来自有赞前端团队. https://github.com/youzan/vant

### 安装

```sh
npm i vant -S
# 或者
yarn add vant
```

### 配置按需加载

安装

```sh
npm i babel-plugin-import -D
```

配置babel.config.js

```js
module.exports = {
   plugins: [
    ['import', {
      libraryName: 'vant',
      libraryDirectory: 'es',
      style: true
    }, 'vant']
  ]
}
```

### 引入组件

最好单独维护

```
import Vue from 'vue'
import { Button } from 'vant';
Vue.use(Button);
```

### 使用组件

```html
<template>
  <div id="app">
      <van-button type="primary">主要按钮</van-button>
      <van-button type="info">信息按钮</van-button>
      <van-button type="default">默认按钮</van-button>
      <van-button type="warning">警告按钮</van-button>
      <van-button type="danger">危险按钮</van-button>
  </div>
</template>
```

## Element UI 

PC 端组件库, 来自饿了么团队

https://element.eleme.cn/

### 安装

按需加载`babel.config.js`配置

```js
module.exports = {
  presets: [
    '@vue/app',
    ["@babel/preset-env", { "modules": false }]
  ],
  "plugins": [
    [
      "component",
      {
        "libraryName": "element-ui",
        "styleLibraryName": "theme-chalk"
      }
    ]
  ]
}
```

