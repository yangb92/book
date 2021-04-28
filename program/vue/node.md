# 小笔记

## vm 单位

px 单位是固定像素大小, vm 单位可以随着屏幕尺寸大小而变化

## 全局进度条插件 NProgress

安装:

```
npm i NProgress -S
```

使用:

```js
// 进度条模块
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'

axios.interceptors.request.use(config => {
  NProgress.start()
  return config
})

axios.interceptors.response.use(response =>{
  NProgress.done()
  return response
})
```