# Gitboot 

## 将gitbook 发布至gitpage

* 在github开启gitpage 
* 打包gitbook `gitbook build`
* 安装同步插件` cnpm install -g gh-pages`
* 将gitbook发布至github `gh-pages -d _book`
* 在gitpage的source选择gh-pages分支, 范围url即可