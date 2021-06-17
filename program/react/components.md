# React 组件

## 创建组件: 方式一

```jsx
import React from 'react' //创建组件, 虚拟DOM元素,生命周期
import ReactDOM from 'react-dom' // 把创建好的组件 和 虚拟DOM 放到页面展示
/*************定义一个组件******************/
function Hello(props){ // props为组件接收的参数, 为只读属性
    return <h1>姓名: {props.name} 年龄: {props.age} 性别: {props.gender}</h1>
}
/********************************************/

ReactDOM.render(
    <div>
        {/* 使用组件,传递props数据 */}
        <Hello name='杨斌' age='27' gender='man'/>
    </div>,
    document.getElementById("app"))
```



> TIP: 
>
> * 组件函数的首字母必须大写
>
> * 展开运算符  ...  将对象属性展开传递给组件
>
> ```js
> const user = {
>     name:'Yangb',
>     age:27,
>     gender:'Nan'
> }
> <Hello {...user}/>
> ```



## 将组件抽出到单独的文件

### 创建Hello.jsx

```
src/
	|--components/
		|--Hello.jsx 
	|--index.js
	|--index.html
```

Hello.jsx

```jsx
import React from 'react'

//定义一个组件 props为组件接收的参数, 为只读属性
export default function Hello(props){
    return <h1>      
         姓名: {props.name} 年龄: {props.age} 性别: {props.gender}
    </h1>
}
```

### 在index.js中导入使用Hello组件

```js
import Hello from './components/Hello.jsx' //后缀名jsx不能省略
...
<div>
	<Hello {...user}/>
</div>
```

### 配置省略 jsx 后缀名

如果看到导入`import Hello from '@/components/Hello'` ,定义了@为绝对路径

webpack.config.json 中配置

```json
    resolve: {
        extensions: ['.js','.jsx','.json'], //表示这几个后缀名可省略不写
        alias: {
            '@': path.join(__dirname,'./src') //@ 表示src这个路径
        }
    }
```



## 创建组件: 方式二

ES6 的 class 定义 

```typescript
// 定义一个动物类
// 注意1: 在class 内部只能写构造器,静态方法,静态属性
// 注意2: class关键字内部,还是用原来的配方,我们把class称为语法糖
class Animal{

    // 构造器 
    constructor(name,age){
        this.name = name
        this.age = age
    }

    // 在class内部通过static修饰的属性是静态属性
    static info = 'xxx'

    //实例方法 -> 存在原型中
    say(){
        console.log("我是实例方法")
    }
    
    //静态方法 -> 存在构造中
    static show(){
        console.log("我是静态方法")
    }
}
```

继承: 

* this 只能在super()后面使用

```typescript
class Person extends Animal{
    
    constructor(name, age, hair){
        super(name,age)
        this.hair = hair  
    }
}
```

### 使用Class创建一个组件

```jsx
class Hello extends React.Component{
	// 在render方法中返回虚拟jsx的dom, 传入参数可通过this.props获取
    render(){
        return <h1>姓名: {this.props.name}</h1>
    }
}
```



## 两种方式的对比

```jsx
class Hello extends React.Component{

    constructor(){
        super()
        this.state = {  //这里面的数据可自由修改
            msg:'我是一个组件'
        }
    }

    render(){
        this.state.msg += '!' //修改值
        return <h1>姓名: {this.state.msg}</h1>
    }
}
```



> class 创建的组件有自己的私有数据和生命周期函数

1. 用**构造函数**创建出的组件,叫做"无状态组件"
2. **class 关键字**创建出来的组件叫做"有状态组件"

> 1.有状态组件和无状态组件的本质却别就是:有无state属性
>
> 2.无状态组件的运行效率更高



## 例子1: 用组件展示一个简单的评论列表

文件结构

```
|src

​	|components

​		|CmtItem.jsx

​		|CmtList.jsx

​	|index.js

​	|index.html
```

CmtItem.jsx

```jsx
import React from 'react'

// 一个无状态组件,接收参数返回一个评论的条目
export default function(props){

    return <div key={props.id}>
        <h1>姓名: {props.user}</h1>
        <p>评论: {props.content}</p>
    </div>
}
```

CmtList.jsx

```jsx
import React from  'react'
import CmtItem from '@/components/CmtItem'

// 评论列表组件 初始化数据,传递给条目
export default class CmtList extends React.Component{

    constructor(){
        super()
        this.state = {
            CommentList:[
                {id:1,user:'张三',content:'nice'},
                {id:2,user:'李四',content:'good'},
                {id:3,user:'王五',content:'excting'}
            ]
        }
    }

    render(){
        return this.state.CommentList.map(Item => <CmtItem {...Item} key={Item.id}></CmtItem>)
    }
}
```

index.js

```jsx
//1. 这两个包导入格式固定
import React from 'react' //创建组件, 虚拟DOM元素,生命周期
import ReactDOM from 'react-dom' // 把创建好的组件 和 虚拟DOM 放到页面展示

import CmtList from '@/components/CmtList'


ReactDOM.render(
    <CmtList>
    </CmtList>,
    document.getElementById("app"))
```



## 样式

行内样式定义如下, 样式属性类型要按照json规范书写

```html
<div style=\{\{color:'red'\}\} ><div>
```

### 定义样式的三种方法

#### 方法一和方法二:

```jsx
/* 第一种封装方法 */
const itemStyle = {border:'1px dashed #ccc',margin:'10px',padding:'10px',boxShadow:'0 0 10px #ccc'}
const userStyle = {fontSize:"14px"}
const contentStyle = {fontSize:"12px"}

/** 第二种封装方法 */
const styles = {
    itemStyle : {border:'1px dashed #ccc',margin:'10px',padding:'10px',boxShadow:'0 0 10px #ccc'},
    userStyle : {fontSize:"14px"},
    contentStyle : {fontSize:"12px"}
}
{/*使用第一种封装*/}
<p style={userStyle}>评论人: {props.user}</p>
{/*使用第二种封装*/}
<p style={styles.contentStyle}>评论内容: {props.content}</p>
```

#### 方法三: 导入css样式文件

* 安装插件`npm i style-loader css-loader -D`
* `webpack.config.js` 中配置插件, 为了避免css全局化互相影响,启用css-loader模块化

```js
... 
module: { //所有第三方模块的配置
    rules: [ //匹配规则
        ...
        //css 样式插件, css-loader的modules参数代表css样式模块化, 只在当前引入的模块起作用, 不添加此参数,样式会在全局中起作用
        {test: /\.css$/, use: ['style-loader', 'css-loader?modules']} 
    ]
}
...
```

##### 编写css文件

```css
.title {
    text-align:center;
    color:red;
    font-size:28px;
    font-weight:300;
}
```

##### 导入css文件

```jsx
import cssobj from '@/components/cmt.css'

//启用css模块化
<h1 className={cssobj.title}>评论列表</h1>

//如果没启用模块化,直接用css定义的class名称即可
<h1 className='title'>评论列表</h1>
```

##### 设置模块化后的类名称

css-loader添加参数

```js
'css-loader?modules&localIdentName=[path][name]-[local]-[hash:5]'
```

##### 设置类名是否被模块化

`:global`不会被模块化 `:local` 会被模块化, 默认

```css
:global(.test){ italic }
```



#### 在项目中启用模块化并同时使用bootstrap

1. 把自己的样式表定义为`.scss`文件
2. 第三方样式表以`.css`样式结尾
3. 我们只需要为自己的`.scss`文件启用模块化即可.

操作步骤

* 安装插件 `cnpm i sass-loader node-sass -D`
* 配置插件,处理.scss文件,不处理.css文件

```js
{test: /\.scss$/,use:['style-loader','css-loader?modules&localIdentName=[path][name]-[local]-[hash:5]','sass-loader']}
{test: /\.css$/, use:['style-loader','css-loader']}
```

安装bootstrap `npm i bootstrap@3.3.7 -S`

导入 `import 'bootstrap/dist/css/bootstrap.css'`

>
>
>如果出现.svg  .ttf .woff .eot 字体无法处理, 添加一下插件
>
>```
>cnpm i url-loader file-loader -D
>```
>
>配置插件处理字体文件
>
>```
>{test: /\.ttf|woff|woff2|eot|svg$/, use: ['url-loader']}
>```



## React 的生命周期

生命周期函数 (或者钩子函数)

React组件的生命周期分为三部分

### 一个定时器的例子

```jsx
import React from 'react'

export default class Lifecycle extends React.Component{

    constructor(){
        super()
        this.state = {date: new Date()}
    }

    /**
     * 组件挂载的时候初始化一个定时器 调用tick方法
     */
    componentDidMount(){
        this.timerID = setInterval(
            () => this.tick(),
            1000
          );
    }

    /**
     * 组件卸载的时候清除定时器
     */
    componentWillUnmount(){
        clearInterval(this.timerID);
    }

    /**
     * 定时器中更新状态
     */
    tick(){
        this.setState({
            date: new Date()
        })
    }

    render(){
        return (
            <div>
                <h1>北京时间:</h1>
                <h2>{this.state.date.toLocaleTimeString()}</h2>         
            </div>
        )
    }

}
```



## 条件渲染

```jsx
function Greeting(props){
    if(props.loginState){
        return <UserGreeting/>
    }
    return <GuestGreeting/>
}

function LoginButton(props){
    if(props.loginState){
        return <button onClick={props.logout}>退出</button>
    }
    return <button onClick={props.login}>登陆</button>
}
```

## FORM表单

```jsx
import React from 'react'

export default class Form extends React.Component{

    constructor(){
        super()
        this.state = {value: ''}
    }

    render(){
        return(
            <form onSubmit={this.handleSubmit}>
                <label>
                    名字: 
                    <input type="text" value={this.state.value} onChange={this.handleChange} />
                </label>
                <input type="submit" value="提交"/>
            </form>
        )
    }

    handleSubmit = (event)=>{
        alert('提交的名字:' + this.state.value)
        // 阻止事件的执行
        event.preventDefault() 
    }

    handleChange = (event) => {
        this.setState({value:event.target.value})
    }

}
```



