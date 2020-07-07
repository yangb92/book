# FTP 服务安装

vsftpd

## centos 安装 vsftpd

```bash
yum install vsftpd -y
```

配置文件
```bash
vim /etc/vsftpd/vsftpd.conf
```
vsftpd.conf 配置

```properties
# 修改
## 关闭匿名访问
anonymous_enable=NO
## 开启白名单访问
chroot_local_user=YES
# 新增
## 文件存放目录
local_root=/data/ftp
## 权限设置
allow_writeable_chroot=YES
```
添加ftp用户(用户目录和前文设置的文件存放目录一致),用户名ftpuser
```
useradd -d /data/ftp -g ftp -s /usr/sbin/nologin ftpuser
```

设置密码

```
passwd ftpuser
```

设置ftp用户
```sh
cd /etc/vsftpd
echo ftpuser>chroot_list
```

如果上传下载权限不足
```
chown ftpuser:ftp -R /data/ftp
```

# Nginx文件下载代理配置

```nginx
location ~ ^/static/.*\.(gif|GIF|jpg|JPG|jpeg|JPEG|bmp|BMP|png|PNG|ico|ICO|gz|csv|xls|xlsx|rar|zip|apk|txt|doc|docx|pdf|ppt|pptx)$ {
        root  /data/ftp/;
        if ($request_uri ~* ^.*\/(.*)\.(gz|csv|xls|xlsx|rar|zip|apk|txt|doc|docx|pdf|ppt|pptx)(\?n=([^&]+))$) {
            add_header Content-Disposition "attachment;filename=$arg_n.$2";
        }
        expires 1h;
        access_log on;
        #deny all;
}
```

