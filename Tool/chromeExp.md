# Chrome 插件开发

mainfest.json

```json
{
    "name": "WSBS",
    "description": "网上办事大厅扩展功能",
    "version": "1.0",
    "manifest_version": 2,
    "browser_action": {
        "default_popup": "main.html",
        "default_icon": "main.png"
    },
    "permissions": [
        "tabs"
      ]
}
```

main.html

```html
<html>

<head>
    <meta charset="utf-8">
    <style>
        body {
            width: 250px;
            text-align: center;
        }

        #build {
            width: 100%;
            background-color: brown;
            color: lightyellow;
            border: none;
            height: 30px;
        }
    </style>
</head>

<body>
    <h2 style="color: brown;">甘肃人力资源网上办事大厅</h2>
    <textarea id='result' style="width: 100%; height: 200px;">
说明: 生成当前页面的授权地址, 实现信任传递.        
    </textarea>
    <hr />
    <button id="build">生成授权地址</button>
</body>
<script src="main.js"></script>

</html>
```

main.js

```js
document.getElementById('build').onclick = function(e){
    chrome.tabs.getSelected(null,function(tab) {
        var pre_url = 'http://www.gszwfw.gov.cn/api/sso/loginTrust?backUrl=http://www.rst.gansu.gov.cn:8080/auth/sso/trust/common/'
        url = tab.url.match(/(\w+):\/\/([^/:]+)(:\d*)?([^# ]*)/).pop()
        document.getElementById('result').textContent = pre_url + window.btoa(url);
    });    
}
```

