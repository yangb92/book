# vuex

![vuex](https://vuex.vuejs.org/vuex.png)

## 安装

```
vue add vuex
```

## 配置

创建 store.js 并在main.js引入

store.js
```js
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    count: 0 //初始化数据
  },
  mutations: {
  },
  actions: {
  },
  modules: {
  }
})

```

main.js

```js
import Vue from 'vue'
import App from './App.vue'
import store from './store'

Vue.config.productionTip = false

new Vue({
  store,
  render: h => h(App)
}).$mount('#app')
```

## 获取 state 的值

在模块中获取state的值

```js
this.$store.state.count
```

## Mutations

操作 state 的中的值, **必须同步执行**

在 store.js 中定义 mutations 方法,操作state

```js
  mutations: {
    INCREMENT(state){
      state.count++
    },
    DECREMENT(state){
      state.count--
    }
  }
```

调用 `mutations` 中的函数.

```js
methods: {
    // ...mapMutations(['INCREMENT','DECREMENT']),
    increment() {
        // this.INCREMENT()
        this.$store.commit('INCREMENT')
    },
    decrement() {
        // this.DECREMENT()
        this.$store.commit('DECREMENT')
    }
},
```

## Action

* Action 提交给 Mutations, 而不直接变更状态.
* Action 可以包含任意异步操作.

定义 Action

```js
  actions: {
    increment({commit}){
      commit('INCREMENT')
    },
    decrement({commit}){
      commit('DECREMENT')
    }
  },
```

调用 Action

```js
this.$store.dispatch('increment')
```


## Getters

state 的计算属性

store.js 中定义 getters 
```js
  getters: {
    des_count: state => {
      return state.count + ".00";
    }
  }
```

使用
```js
this.$store.getters.des_count
```

## Modules

对状态分模块

## 使用 map 方便取值

```js
<script>
import {mapMutations,mapGetters,mapState,mapActions} from 'vuex'

    export default {
        name: 'Counter',
        computed: { 
          //取出 vuex 中的值
            ...mapGetters(['des_count']),
            ...mapState(['count'])
        },
        methods: {
            //取出 Action 方法
            ...mapActions(['increment','decrement'])
        },
    }
</script>
```
