# React 事件

在React有一套自己的事件绑定机制, 事件名是驼峰规则.

示例: 箭头函数的好处是this 环境指的是当前class的环境.可以使用this获取当前class中的属性.



## 修改state的数据

* 在React中,想要为state中的数据重新赋值,不要使用 this.state.*** = 值

* 应该调用 React提供的 this.setState({msg:123})

* 在setState中,只会更新对应的值,而不会覆盖其他的值.
* this.setState的方法执行是异步的,在调用完setState之后要立即获取设置完的值,需要使用this.setState({},callable)



## 示例代码

```jsx
import React from 'react'
import 'bootstrap/dist/css/bootstrap.css'

export default class BindEvent extends React.Component{

    constructor(){
        super()
        this.state = {
            msg: "你好"
        }
    }
    
    render(){
        return <div> 
            {/* 在React有一套自己的事件绑定机制, 事件名是驼峰规则. */}
            <button className='btn' onClick={() => this.show('哈哈')}> 按钮 </button>
            <p>{this.state.msg}</p>
        </div>
    }

    // 箭头函数的好处是this 环境指的是当前class的环境.可以使用this获取当前class中的属性.
    show = (args) => {
        // 在React中,想要为state中的数据重新赋值,不要使用 this.state.*** = 值 
        // 应该调用 React提供的 this.setState({msg:123})
        // 在setState中,只会更新对应的值,而不会覆盖其他的值.
        // this.setState的方法执行是异步的,在调用完setState之后要立即获取设置完的值,需要使用this.setState({},callable)
        this.setState({
            msg:"你说: "+args
        },() => {
            console.log(this.state.msg)
        })
    }
}
```

## 同步文本框的值

React 不支持双向绑定, 只支持将state传输到页面, 无法从页面自动绑定数据到state中,  不支持数据的逆向传输.

将属性绑定到文本框  `value={this.state.xxx}`

将文本框的值同步到属性: 

* 第一步,手动监听文本框的onChange事件
* 第二部: 获取文本框的值
* 第三步: 调用setState方法同步最新的值

```jsx
render(){
    return <div> 
        {/* 在React有一套自己的事件绑定机制, 事件名是驼峰规则. */}
        <button className='btn' onClick={() => this.show('哈哈')}> 按钮 </button>
        <p>{this.state.msg}</p>
        {/* 第一步,手动监听文本框的onChange事件 */}
        <input type='text' value={this.state.msg} onChange={(e) => this.changeTxt(e)} ref='txt' />
    </div>
}

changeTxt = (e) => {
    // 第二部: 获取文本框的值
    //方式一: 通过参数 e 获取
    console.log(e.target.value)
    //方式二: 通过refs属性获取
    console.log(this.refs.txt.value)

    //第三步: 调用setState方法同步最新的值
    this.setState({
        msg: this.refs.txt.value
    })
}
```

## 绑定this并传参的几种方式

* 使用箭头函数
* bing函数`this.xx.bind(this)` 传递当前this. 
* 和call/apply的区别bind 只会修改指向不会调用, 
* bind中的参数传递, 第一个参数是this  `this.method.bind(this,args1,...)`
* 可以在构造函数中执行该方法或在事件中绑定

第三种: 使用箭头函数this的调用即可