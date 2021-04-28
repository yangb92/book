# Maven 仓库介绍

## 代理仓库（Proxy Repository）

意为第三方仓库，如：

- maven-central
- nuget.org-proxy

版本策略（Version Policy）：

- Release: 正式版本
- Snapshot: 快照版本
- Mixed: 混合模式

布局策略（Layout Policy）：

- Strict：严格
- Permissive：宽松

## 宿主仓库（Hosted Repository）

存储本地上传的组件和资源的，如：

- maven-releases
- maven-snapshots
- nuget-hosted

部署策略（Deployment Policy）：

- Allow Redeploy：允许重新部署
- Disable Redeploy：禁止重新部署
- Read-Only：只读

## 仓库组（Repository Group）

通常包含了多个代理仓库和宿主仓库，在项目中只要引入仓库组就可以下载到代理仓库和宿主仓库中的包，如：

- maven-public
- nuget-group