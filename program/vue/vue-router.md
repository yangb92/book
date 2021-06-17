# Vue Router 路由

构建单页面应用  https://router.vuejs.org/

## 安装

```sh
npm i vue-router --save
```

## 基本配置

新建router.js

```js
import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

export default new Router({
    routes:[
        
    ]
})
```

在main.js中引入

```js
import Vue from 'vue'
import App from './App.vue'
import router from './router'

new Vue({
  router,
  render: h => h(App),
}).$mount('#app')

```

## 导航路由和出口路由

路由的配置:

```js
export default new Router({
    routes:[
        {path:'/', redirect:'/home'},
        {path:'/home', name:'home', component: Home},
        {path:'/about', name:'about', component: About},
    ]
})
```

路由出口: 路由的页面在`<router-view/>`中展示
导航路由: 路由的导航地址

在App.vue中

```html
<template>
  <div id="app">
    <!-- 设置路由出口 -->
    <router-view/>
    <!-- 设置路由导航 -->
    <router-link to="/home">首页</router-link>
    <router-link to="/about">关于我们</router-link>
  </div>
</template>
```

## history 和 hash 模式

hash模式: 地址栏是`/#/about`,

history模式: 传统的url模式,有利于seo优化.

通过mode参数使用:

```js
export default new Router({
    mode:'history',
    routes:[...]
})
```

## 动态路由

两个参数: name和age通过路由传递

配置:
```js
    routes:[
        {path:'/mine/:name/:age', name:'mine', component:Mine}
    ]
```

获取: 在组件中获取参数
```js
created () {
    console.log(this.$route.params);
},
```

在props中绑定路由参数

```js
{path:'/mine/:name/:age', name:'mine', component:Mine,props: true}
```

```js
export default {
    name:'Mine',
    props:['name','age']
}
```

## 嵌套路由

配置:

```js
{path:'/home', name:'home', component: Home,children:[
    {path:'/home',redirect:'/home/shop'},
    {path:'news',name:'news',component: News},
    {path:'shop',name:'shop',component: Shop}
]}
```

路由入口防止在 Home 组件中,并设置路由导航

```html
<template>
    <div>
        <h2>家</h2>
        <router-link to="/home/shop">商城</router-link> | 
        <router-link to="/home/news">新闻</router-link>
        <router-view/>
    </div>
</template>
```

## 路由守卫

全局路由的前置守卫: 可用于判断权限.

```js
let router = new Router({
    mode:'history',
    routes:[
        {path:'/', redirect:'/home'},
        {path:'/home', name:'home', component: Home,children:[
            {path:'/home',redirect:'/home/shop'},
            {path:'news',name:'news',component: News},
            {path:'shop',name:'shop',component: Shop}
        ]},
        {path:'/about', name:'about', component: About},
        {path:'/mine', name:'mine', component:Mine}
    ]
})

// 前置守卫
router.beforeEach((to,from,next)=>{
    // 此处可以验证页面的访问权限
    console.log("进入路由");
    next() //放行
})

// 后置守卫
router.afterEach((to,from)=>{
    console.log("路由结束");
})

```

**常用的路由钩子**

1. 导航被触发。
2. 在失活的组件里调用 beforeRouteLeave 守卫。
3. 调用全局的 beforeEach 守卫。
4. 在重用的组件里调用 beforeRouteUpdate 守卫 (2.2+)。
5. 在路由配置里调用 beforeEnter。
6. 解析异步路由组件。
7. 在被激活的组件里调用 beforeRouteEnter。
8. 调用全局的 beforeResolve 守卫 (2.5+)。
9. 导航被确认。
10. 调用全局的 afterEach 钩子。
11. 触发 DOM 更新。
12. 调用 beforeRouteEnter 守卫中传给 next 的回调函数，创建好的组件实例会作为回调函数的参数传入。

## 路由懒加载

安装:
```
npm install --save-dev @babel/plugin-syntax-dynamic-import
```

配置babel.config.js:

```json
{
  "plugins": ["@babel/plugin-syntax-dynamic-import"]
}
```

有时候我们想把某个路由下的所有组件都打包在同个异步块 (chunk) 中。只需要使用 命名 chunk，一个特殊的注释语法来提供 chunk name (需要 Webpack > 2.4)。

```js
//import Foo from './Foo.vue'

const Foo = () => import(/* webpackChunkName: "group-foo" */ './Foo.vue')
const Bar = () => import(/* webpackChunkName: "group-foo" */ './Bar.vue')
const Baz = () => import(/* webpackChunkName: "group-foo" */ './Baz.vue')
```