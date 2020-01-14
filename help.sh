echo "
1. 发布到gitpages [github 和 gitee]
2. 自动提交推送代码 [github 和 gitee]
"

gitbook build
gh-pages -d _book
gh-pages -d _book -o gitee
echo 'http://yangb92.gitee.io/book
https://yangb92.github.io/book/
'

git add .
git commit -m '-> tool auto commit'
git push origin master
git push gitee master

read
