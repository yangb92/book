# Chrome 插件开发

使页面变为可编辑状态
```js
document.body.contentEditable = "true"
```

获取tab的url
```js
chrome.tabs.getSelected(null,function(tab) {
    console.log(tab.url)
});  
```

