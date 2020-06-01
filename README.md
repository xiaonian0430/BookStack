## goproxy.io
```
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.io,direct

# 设置不走 proxy 的私有仓库，多个用逗号相隔（可选）
go env -w GOPRIVATE=*.corp.example.com

# 设置不走 proxy 的私有组织（可选）
go env -w GOPRIVATE=example.com/org_name

erifying github.com/xiaonian0430/gotil@v1.0.1/go.mod: checksum mismatch
go.sum:     h1:0V5BlPJa24R0PzuXVURUfjaQ8Z7cmqsVSW7ftuhesN0=

解决办法
删除go.sum,然后重新生成， go mod tidy 即可
```

## 打包

打包成 Linux 命令
```
bee pack -be GOOS=linux 
```

打包成 Windows 命令 
```
bee pack -be GOOS=windows
```

打包成 Mac 命令 
```
bee pack -be GOOS=darwin
```

## 使用
### 01.安装中文字体（非必须，但是建议安装）
有的Linux服务器并没有支持中文字体，需要手动安装。 地址：http://www.hc-cms.com/thread-41-1-1.html

安装命令：
```
sudo apt install ttf-wqy-zenhei
sudo apt install fonts-wqy-microhei
```

### 02.安装Chrome
直接使用命令一键安装：

```
yum install chromium
```

执行以下命令，如果能打印百度页面代码，则表示安装成功。

```
chromium-browser --headless --disable-gpu --dump-dom --no-sandbox https://www.baidu.com
```

安装chrome，是为了兼容以前的问题，并且自动安装puppeteer的一些chrome浏览器依赖。

### 03.安装puppeteer
这个主要用于在发布文档的时候，渲染未被渲染的markdown文档、渲染自定义封面、以及强力模式下的网页采集。
```
yum install nodejs npm
npm install -g n
n stable
npm install -g cnpm
cnpm install puppeteer
```

### 04.安装calibre
calibre官网：https://www.calibre-ebook.com/

安装命令：
```
wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | python3 -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
```
执行下面命令，能看到版本号，表示安装成功。
```
ebook-convert --version
```

注意：

这里要安装最新版的calibre，执行上述命令，安装的就是最新版的了。
如果出现warning的提示，直接不用理会即可;error级别的提示，网上搜下看下如何解决
calibre主要用于将文档导出生成pdf、epub、mobi文档。

本人已经使用Go语言对calibre导出pdf、epub、mobi文档进行了一层封装，欢迎大家给个star ==》https://github.com/xiaonian0430/converter

测试：随便创建一个txt文件
```
echo "Hello xiaonian。你好，阿休。" > test.txt
```

转成pdf

```
ebook-convert test.txt test.pdf
```
查看测试的转化效果，主要看下转化的过程中有没有报错，以及转化后的文档有没有出现中文乱码。

### 05.配置文件在conf目录
app.conf

oss.conf

oauth.conf

### 06.部署打包的软件

执行数据库安装。程序安装一些站点配置项、SEO项等:
```
./ShareKnow install
```

启动：
```
./ShareKnow
```

### 07.Nginx反向代理配置参考：
```

server
{
    listen 80;
    server_name demo.sk.showcm.top;
    index index.php index.html index.htm default.php default.htm default.html;
    root /www/wwwroot/demo.sk.showcm.top;
    location / 
    {
        proxy_pass http://localhost:8100;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header REMOTE-HOST $remote_addr;
        #缓存相关配置
        #proxy_cache cache_one;
        #proxy_cache_key $host$request_uri$is_args$args;
        #proxy_cache_valid 200 304 301 302 1h;
        #持久化连接相关配置
        #proxy_connect_timeout 30s;
        #proxy_read_timeout 86400s;
        #proxy_send_timeout 30s;
        #proxy_http_version 1.1;
        #proxy_set_header Upgrade $http_upgrade;
        #proxy_set_header Connection "upgrade";
    }
    location ~ .*\.(php|jsp|cgi|asp|aspx|flv|swf|xml)?$
    {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header REMOTE-HOST $remote_addr;
        proxy_pass http://localhost:8100;
    }
    #PROXY-END
    include enable-php-54.conf;
    #PHP-INFO-END
    #REWRITE-START URL重写规则引用,修改后将导致面板设置的伪静态规则失效
    include /www/server/panel/vhost/rewrite/demo.sk.showcm.top.conf;
    #REWRITE-END
    #禁止访问的文件或目录
    location ~ ^/(\.user.ini|\.htaccess|\.git|\.svn|\.project|LICENSE|README.md)
    {
        return 404;
    }
    access_log  off;
}
```

### 08.加入系统守护进行

1、进入supervisor的配置目录
```
yum install -y supervisor
cd /etc/supervisord.d
```

2、配置守护进程 创建 shareknow.ini文件，并配置。
```
[program:ShareKnow]
directory = 你的程序目录
command =你的程序执行命令
autostart = true
autorestart=true
user = 启动该程序的用户
redirect_stderr = true
stdout_logfile = 日志地址
```
配置示例：
```
[program:ShareKnow]
directory = /home/ShareKnow
command =/home/ShareKnow/ShareKnow
autostart = true
autorestart=true
user = root
redirect_stderr = true
stdout_logfile = /var/log/supervisor/ShareKnow.log
```

配置完成之后，重启supervisor
```
# 启动
supervisord -c /etc/supervisord.conf

# 重启
supervisorctl reload

# 查看进程
supervisorctl status

# 启动某个进程
supervisorctl start ShareKnow

# 停止某个进程
supervisorctl stop ShareKnow

# 重启某个进程
supervisorctl restart ShareKnow


# error: <class 'socket.error'>, [Errno 2] No such file or directory: file: /usr/lib64/python2.7/socket.py line: 224

解决办法：
这个可能有多种原因，可能是已经启动过了也可能是没权限，解决步骤如下：
1. 先要确认是否已经启动过了：’ps -ef | grep supervisord’
2. 如果有的话先kill掉
3. 运行下面命令：
sudo touch /var/run/supervisor.sock
sudo chmod 777 /var/run/supervisor.sock

4. 再尝试重新启动：supervisord -c /etc/supervisord.conf(如果没有文件找个别人的配置拷贝过来或者运行echo_supervisord_conf > /etc/supervisord.conf)
```


默认管理员账号和密码

admin admin  或者 admin admin888




## 正文
**ShareKnow 配套手机APP `ShareKnowApp` 开源地址**

- GitHub: https://github.com/xiaonian0430/ShareKnowApp

**BookChatApp下载体验地址**

- https://sk.showcm.top/app

目录：
- [ShareKnow 简介](#intro)
    - [功能与亮点](#func)
		- [生成和导出PDF、epub、mobi等离线文档](#generate)
		- [文档排序和批量创建文档](#sort)

    
<a name="intro"></a>
# ShareKnow 简介

ShareKnow ，分享知识，共享智慧！知识，因分享，传承久远！

ShareKnow 是基于[Mindoc](https://github.com/lifei6671/mindoc)开发的，为运营而生。

在开发的过程中，增加和移除了一些东西，目前已经不兼容 MinDoc 了（毕竟数据表结构、字段、索引都有了一些不同），同时只支持 markdown 编辑器。

> 目前已支持Git Clone导入项目

<a name="generate"></a>
### 生成和导出PDF、epub、mobi等离线文档
这个需要安装和配置calibre。
我将calibre的使用专门封装成了一个工具，并编译成了二进制，源码、程序和使用说地址：[https://github.com/TruthHun/converter](https://github.com/TruthHun/converter)
在ShareKnow中，已经引入这个包了。使用的时候，点击"生成下载文档"即可

<a name="sort"></a>
### 文档排序和批量创建文档
很多时候，我们在写作文档项目的时候，会习惯地先把文档项目的章节目录结构创建出来，然后再慢慢写内容。
但是，文档项目中的文档少的时候，一个个去创建倒没什么，但是文档数量多了之后，简直就是虐待自己，排序的时候还要一个一个去拖拽进行排序，很麻烦。现在，这个问题已经解决了。如下：
- 在文档项目中，创建一个文档标识为`summary.md`的文档(大小写不敏感)
- 在文档中，填充无序列表的markdown内容，如：

```markdown
<ShareKnow-summary></ShareKnow-summary>
* [第0章. 前言]($ch0.md)
* [第1章. 修订记录]($ch1.md)
* [第2章. 如何贡献]($ch2.md)
* [第3章. Docker 简介]($ch3.md)
    * [什么是 Docker]($ch3.1.md)
    * [为什么要用 Docker]($ch3.2.md)
* [第4章. 基本概念]($ch4.md)
    * [镜像]($ch4.1.md)
    * [容器]($ch4.2.md)
    * [仓库]($ch4.3.md)
```
- 然后保存。保存成功之后，程序会帮你创建如"第0章. 前言"，并把文档标识设置为"ch0.md"，同时目录结构还按照你的这个来调整和排序。

注意：
> 必须要有`<ShareKnow-summary></ShareKnow-summary>`，这样是为了告诉程序，我这个`summary.md`的文档，是用来创建文档和对文档进行排序的。当然，排序完成之后，当前页面会刷新一遍，并且把`<ShareKnow-summary></ShareKnow-summary>`移除了。有时候，第一次排序并没有排序成功，再添加一次这个标签，程序会自动帮你再排序一次。
> 我自己也常用这种方式批量创建文档以及批量修改文档的标题





<a name="install"></a>
## 安装与使用


为了方便，安装和使用教程，请移步到这里：http://www.ShareKnow.cn/read/help/Ubuntu.md

> 目前只写了Ubuntu下的安装教程，Windows下的安装和使用教程，暂时没时间

有两个模板文件，需要手动修改下：
`/views/widgets/pdf_footer.html` 导出PDF文档时，pdf的footer显示内容
`/views/document/tpl_statement.html` 修改成你想要的文案内容或者删除该文件。如果保留该文件，必须要有`h1`标签，因为程序要提取你的`h1`标签用于导出文档的目录生成
