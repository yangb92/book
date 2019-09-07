# OAuth2

## 名次定义

* Third-party application：第三方程序，即client
* Http Service：Http服务提供商
* Resource Owner：资源所有者，即用户 user
* User Agent：用户代理，本文指浏览器
* Authorization Server：认证服务器，即服务提供商专门处理认证的服务器。
* Resource Server：资源服务器，即服务提供商存放用户资源的服务器，它与认证服务器可以是同一台服务器，也可是不同服务器。

知道上面的名次，就不难理解 OAuth 的作用就是让客户端安全的获取用户的授权。

## OAuth 的思路

OAuth在客户端与提供商之间设置了一个授权层，客户端不能直接登陆服务提供商，只能登陆授权层（Authorization layer），"客户端"登录授权层所用的令牌（token），与用户的密码不同。用户可以在登录的时候，指定授权层令牌的权限范围和有效期。

"客户端"登录授权层以后，"服务提供商"根据令牌的权限范围和有效期，向"客户端"开放用户储存的资料。

## 运行流程

![](OAuth_img1.png)

（A）用户打开客户端以后，客户端要求用户给予授权。

（B）用户同意给予客户端授权。

（C）客户端使用上一步获得的授权，向认证服务器申请令牌。

（D）认证服务器对客户端进行认证以后，确认无误，同意发放令牌。

（E）客户端使用令牌，向资源服务器申请获取资源。

（F）资源服务器确认令牌无误，同意向客户端开放资源。

## 授权模式

* 授权码模式 Authorization code
* 简化模式 implicit
* 密码模式 resource owner password credentials
* 客户端模式

## 授权码模式