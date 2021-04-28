# 网络请求

## 反向代理

在 vue.config.js 文件中配置, 如果没有该文件, 在根目录创建该文件,将由vue框架自动加载.

```js
module.exports = {
    devServer:{
        proxy:{
            '/ajax':{
                target:'https://m.maoyan.com',
                changeOrigin:true
            }
        }
    }
}
```

## axios

### 安装

```sh
npm i axios -S
```

### 配置

在`src/`目录创建 http.js

```js
import axios from 'axios'

const http = axios.create({
    baseURL: 'http://localhost/web/api'
})

export default http;
```

配置在vue的原始类型中方便使用

main.js

```js
import Vue from 'vue'
import http from '@/http'

Vue.prototype.$http = http
```

### 使用

```js
this.$http.post('/getSingleJoke?sid=28654780',{name:this.name,username:this.username,password:this.password}).then(resp => {
    console.log(resp)
})
```



