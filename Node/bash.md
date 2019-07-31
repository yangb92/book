# Node.js 常用脚本收集

## npm 管理的项目一键部署

在项目根目录的package.json文件中找到scripts，相信你能看到不少命令，start、build等等，在此处增加一条命令，内容大概如下：

```json
`"dist": "npm run build && rsync -p22 -avz --delete-after dist/ root@x.x.x.x:/opt/site/test/antd-pro",`
```

运行：

```
yarn dist
```

或者

```
npm run dist
```

解释：
这句话会先执行`npm run build`然后再将dist目录下的所有文件拷贝到目标服务器，当然需要您配好本地到服务器的免密登录。