# Git

## Gitbook

### 将打包的文档发布至公共 gitpage

* 在 github|gitee 创建一个仓库
* 创建gitbook文档, 使用 `gitbook build`打包
* 安装推送插件` cnpm install -g gh-pages`
* 将文档发布到github|gitee `gh-pages -d _book`
* 开启仓库的gitpage, 选择gh-pages分支. 

### 本文档使用插件

```json
{
    "title":"学习笔记",
    "author":"杨斌",
    "language" : "zh-hans",
    "plugins": [
        "-search",
        "back-to-top-button",
        "chapter-fold",
        "-sharing", 
        "sharing-plus",
        "donate",
        "pageview-count",
        "search-pro",
        "insert-logo",
        "theme-default",
        "theme-comscore"
    ], 
    "styles": {
        "website": "styles/website.css"
    },
    "pluginsConfig": {
        "sharing": {
            "douban": true,
            "weibo": true,
            "qzone": true,
            "qq":true,
            "all": [
                "douban", "facebook", "google",
                "linkedin","twitter", "weibo", 
                "messenger","qq", "qzone","weibo"
            ]
       },
       "donate": {
            "wechat": "https://gitee.com/yangb92/book/raw/gh-pages/git/wxpay.png",
            "alipay": "https://gitee.com/yangb92/book/raw/gh-pages/git/alipay.png",
            "title": "",
            "button": "赏",
            "alipayText": "支付宝打赏",
            "wechatText": "微信打赏"
        },
        "insert-logo": {
            "url": "https://gitee.com/yangb92/book/raw/gh-pages/favorite.png",
            "style": "background: none; max-height: 80px; min-height: 10px"
        },
        "theme-default": {
            "showLevel": true
        }
    }
}
```
