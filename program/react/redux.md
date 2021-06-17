# Redux  
简单理解，它是用来管理前端的状态中心
三个重要部分

* action 传输数据到store 
* reducer 指定了应用状态的变化如何响应 actions 并发送到 store 的，记住 actions 只是描述了有事情发生了这一事实，并没有描述应用如何更新 state。
* store 就是把它们联系到一起的对象 **Redux 应用只有一个单一的 store**

## react-redux
npm i redux react-redux -S