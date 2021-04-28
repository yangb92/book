# VUE

学习代码: https://github.com/yangb92/admin-vue-elementui

## vue-cli

1. 安装

```
npm install -g @vue/cli
```

2. 适用脚手架创建项目

```
vue create demo
```

## MVVM介绍

.vue 文件包括 template, script, style. 在scrpt暴露该组件,供外部使用.

```html
 - 模板
<template>
<!-- template 只能有一个子元素 -->
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.png">
    <!-- 3.使用组件 -->
    <HelloWorld/>
  </div>
</template>

- 脚本
<script>
// 1. 引入组件
import HelloWorld from './components/HelloWorld.vue'

export default {
  name: 'App',
  components: {
    // 2. 注册组件
    HelloWorld
  }
}
</script>

- 样式
<style>
#app {
...
}
</style>

```

## 数据绑定

`v-model`, `v-bind` 等等.

Vue.extend() 中 data 必须是函数.

例如:
```html
<template>
  <div>
    <h1>{{msg}}</h1>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data(){
    return {
      msg:'Hello Vue'
    }
  }
}
</script>
```

## 事件绑定

绑定一个点击事件,例如:

```html
<template>
  <div>
    <button @click=study >点击</button>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  methods:{
    study(){
      alert("学有所成!")
    }
  }
}
```

其他事件:
```html
<!-- 按键 -->
<input v-on:keyup.13="submit">
```
特定事件
.enter
.tab
.delete (捕获“删除”和“退格”键)
.esc
.space
.up
.down
.left
.right

## 计算属性

c 属性是计算得出的,计算逻辑写在此函数中

```js
var vm = new Vue({
  data: { a: 1 },
  computed: {
    // 仅读取
    aDouble: function () {
      return this.a * 2
    },
    // 读取和设置
    aPlus: {
      get: function () {
        return this.a + 1
      },
      set: function (v) {
        this.a = v - 1
      }
    }
  }
})
vm.aPlus   // => 2
vm.aPlus = 3
vm.a       // => 2
vm.aDouble // => 4
```

## Watch 观察属性

观察属性的变化

```js
var vm = new Vue({
  data: {
    a: 1,
    b: 2,
    c: 3,
    d: 4,
    e: {
      f: {
        g: 5
      }
    }
  },
  watch: {
    a: function (val, oldVal) {
      console.log('new: %s, old: %s', val, oldVal)
    },
    // 方法名
    b: 'someMethod',
    // 该回调会在任何被侦听的对象的 property 改变时被调用，不论其被嵌套多深
    c: {
      handler: function (val, oldVal) { /* ... */ },
      deep: true
    },
    // 该回调将会在侦听开始之后被立即调用
    d: {
      handler: 'someMethod',
      immediate: true
    },
    // 你可以传入回调数组，它们会被逐一调用
    e: [
      'handle1',
      function handle2 (val, oldVal) { /* ... */ },
      {
        handler: function handle3 (val, oldVal) { /* ... */ },
        /* ... */
      }
    ],
    // watch vm.e.f's value: {g: 5}
    'e.f': function (val, oldVal) { /* ... */ }
  }
})
vm.a = 2 // => new: 2, old: 1
```

## 动态样式

```html
<!-- class 绑定 -->
<div :class="{ red: isRed }"></div>
<div :class="[classA, classB]"></div>
<div :class="[classA, { classB: isB, classC: isC }]">
```

## 元素控制

`v-if, v-show, v-else, v-else-if`

```html
<div v-if="type === 'A'">
  A
</div>
<div v-else-if="type === 'B'">
  B
</div>
<div v-else-if="type === 'C'">
  C
</div>
<div v-else>
  Not A/B/C
</div>
```

## 数据遍历

**v-for**

预期：Array | Object | number | string | Iterable (2.6 新增)

```html
<div v-for="item in items">
  {{ item.text }}
</div>
<div v-for="(item, index) in items"></div>
<div v-for="(val, key) in object"></div>
<div v-for="(val, name, index) in object"></div>
```

v-for 的默认行为会尝试原地修改元素而不是移动它们。要强制其重新排序元素，你需要用特殊 attribute key 来提供一个排序提示：

```html
<div v-for="item in items" :key="item.id">
  {{ item.text }}
</div>
```

## 通过计算属性进行过滤和排序

过滤: `arr = student.filter(p => p.name.indexOf(search) !== -1)`

排序: `sort((p1,p2) => p1.age - p2.age)`

## 其他属性

- `v-text`: 插入文本  `<span v-text="msg"></span>`

- `v-html`: 插入普通html

- `v-pre`:  不渲染元素内容

- `v-once`: 只渲染元素和组件一次。 

```html
<span v-once>This will never change: {{msg}}</span>
```

## 特殊属性

- key: 有相同父元素的子元素必须有独特的 key。重复的 key 会造成渲染错误。 常见v-for结合使用

- ref: 用来或取元素的

例子:
```html
<!-- `vm.$refs.p` will be the DOM node -->
<p ref="p">hello</p>

<!-- `vm.$refs.child` will be the child component instance -->
<child-component ref="child"></child-component>

...

<script>
this.$refs.p.text // => hello
</script>
```

## 自定义全局指令和局部指令

**注册全局指令**

```js
// 注册 (指令函数)
Vue.directive('my-directive', function (el, binding) {
  // 这里将会被 `bind` 和 `update` 调用
})
```

使用

```html
<p v-uwords="'hello Iter'" v-focus>Hello Iter</p>
```

**局部指令**

```html
<template>
    <div>
        <p v-focus>Hello Iter</p>
    </div>
</template>

<script>
export default {
    name: "Iter",
    directives: {
        focus:function(el, binding){
            el.style="color:red"
        }
    }
}
</script>
```

## 过滤器

**局部过滤器**

```js
export default {
    name: "Iter",
    filters: {
        telFormat: function(value) {
            return "☎️ " + value;
        }
    }
}
```

**全局过滤器**

```js
Vue.filter("moneyFormat",function(value){
  return "¥" + value + ".00"
})

```

**使用**

```js

```

## 动画和过渡

略

## 生命周期

![](https://cn.vuejs.org/images/lifecycle.png)

```js
<script>
export default {
    name: "Iter",
    // 元素创建
    created () {
        this.time_a = new Date().getTime()
    },
    // 元素挂载
    mounted () {
        console.log('用时:' + (new Date().getTime()-this.time_a) + "mm");
    },
}
```

## 组件通信

### props 

用于外部向内部传输数据

内部组件接收并显示数据

```html
<template>
    <div>
        姓名: {{name}} <br/>年龄: {{age}}
    </div>
</template>

<script>
    export default {
        name: 'Message',
        // props: ['name', 'age'],
        props:{
            name: {type:String, default: "yangb"},
            age: {type: Number, required: true},
            home: Object
        }        
    }
</script>
```

外部组件调用

```html
<Message name='Zhang san' :age=28 />
```

> 注意传递对象或数字的时候,需要使用动态绑定, v-bind


### 自定义事件传递参数

只适用子组件向父组件传递数据

子组件发送数据:

```js
this.$emit('welcom',{age:14})
```

父组件响应事件

```html
<Message name='Zhang san' v-on:welcom="changeT" :age=28 />
<script>
//...
  methods: {
    changeT(args) {
      console.log(args)
    }
  },
//...
}
</script>

```

或者使用下面的方法接收事件

```js
this.$refs.msg.$on("welcom",this.changeT);
```

### PubSub 发布订阅

插件安装

```sh
npm install --save pubsub-js
```

引入

```js
import PubSub from 'pubsub-js'
```

发布
```js
PubSub.publish('delTodo',"参数")
```

订阅

```js
PubSub.subscribe('delTodo',(msg,token) => {console.log(msg,token)})
```

## 插槽

组件中预留插槽: **slot**

```html
<template>
    <div>
        <slot name='head'></slot>
    </div>
</template>
```

使用插槽

```html
<template>
  <div id="app">
    <Box>
        <input type="text" slot="head">
    </Box> 
  </div>
</template>
```
