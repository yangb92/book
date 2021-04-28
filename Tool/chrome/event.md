# Chrome 事件监听和响应

Chrome 插件为了安全性不能直接操作页面元素, 因此需要利用事件监听和响应来传递信息

**案例: 修改哔哩哔哩视屏列表宽度**

创建监听器的js
bili.js 
```js
chrome.extension.onRequest.addListener(//监听扩展程序进程或内容脚本发送的请求
    function (request, sender, sendResponse) {
        if (request.action == "multi_page") {
            document.getElementById('multi_page').style="width:500px"
        }
        sendResponse({"success":"成功"})
    }
);
```

插件的弹出页
main.html 
```html
<meta charset="utf-8">
<button id="b_video_list">B站视屏列表标题展开</button>
<script src="main.js"></script>
```

在弹出页向监听器发送事件
main.js
```js
document.getElementById('b_video_list').onclick = function(e){
    chrome.tabs.getSelected(null, function (tab) {//获取当前tab
        //向tab发送请求
        chrome.tabs.sendRequest(tab.id, { action: "multi_page" },function(response){
            console.log(response.success)
        });
    });
}
```

在 manifest.json 中配置

```json
{
    "name": "ybtool",
    "description": "杨斌的工具包",
    "version": "1.0",
    "manifest_version": 2,
    "browser_action": {
        "default_icon": "main.png",
        "default_popup": "main.html"
    },
    "content_scripts": [
        {
            "matches": ["https://www.bilibili.com/*"], // 为相关页面加上监听器
            "js": ["bili.js"]
        }
    ],
    "permissions": ["https://www.bilibili.com/video/*","tabs"]
}
```

## 直接修改指定网站的DOM

https://github.com/GoogleChrome/chrome-extensions-samples

manifest.json

```json
{
    "name": "zhihu",
    "action": {},
    "manifest_version": 3,
    "version": "0.1",
    "description": "Turns the page red when you click the icon",
    "content_scripts": [
        {
            "matches": [
                "https://www.zhihu.com/*"
            ],
            "js": [
                "background.js"
            ],
            "all_frames": false
        }
    ],
    "permissions": [
        "https://www.zhihu.com/*",
        "activeTab",
        "scripting"
    ]
}
```

background.js

```js

function reddenPage() {
    document.body.getElementsByClassName('Sticky AppHeader')[0].remove()
    document.body.getElementsByClassName('GlobalSideBar GlobalSideBar--old')[0].remove()
    document.body.getElementsByClassName('ModalExp-content')[0].remove()
}
reddenPage()
```

