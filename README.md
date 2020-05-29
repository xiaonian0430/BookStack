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
./BookStack install
```

启动：
```
./BookStack
```

### 07.Nginx反向代理配置参考：
```

server
{
    listen 80;
    server_name demo.bookstack.cn;
    index index.php index.html index.htm default.php default.htm default.html;
    root /www/wwwroot/demo.bookstack.cn;
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
    include /www/server/panel/vhost/rewrite/demo.bookstack.cn.conf;
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
cd /etc/supervisor/conf.d/
```

2、配置守护进程 创建bookstack.ini文件，并配置。
```
[program:BookStack]
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
[program:BookStack]
directory = /home/BookStack
command =/home/BookStack/BookStack
autostart = true
autorestart=true
user = root
redirect_stderr = true
stdout_logfile = /var/log/supervisor/BookStack.log
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
supervisorctl start BookStack

# 停止某个进程
supervisorctl stop BookStack

# 重启某个进程
supervisorctl restart BookStack


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
**BookStack 配套手机APP `BookChatApp` 开源地址**

- GitHub: https://github.com/xiaonian0430/BookChatApp

**BookChatApp下载体验地址**

- https://www.bookstack.cn/app

目录：
- [BookStack简介](#intro)
    - [开源](#open)
    - [QQ交流群](#qqgroup)
    - [站点](#site)
		- [演示站点](#demo)
		- [正式站点](#normal)
    - [更新、维护和升级](#upgrade)
    - [功能与亮点](#func)
		- [书籍分类](#cate)
		- [用户主页](#homepage)
		- [一键导入markdown项目](#import)
		- [一键拉取markdown项目](#pull)
		- [生成和导出PDF、epub、mobi等离线文档](#generate)
		- [文档排序和批量创建文档](#sort)
		- [文档间的跳转](#redirect)
		- [采集功能](#crawl)
		- [SEO](#seo)
		- [赞助二维码](#qrcode)
		- [更美观、简洁的页面布局和更为完善的移动端兼容](#beauty)
    - [TODO](#todo)
    - [安装与使用](#install)
    - [关于本人](#aboutme)
    - [赞助我](#support)

    
<a name="intro"></a>
# BookStack 简介

BookStack，分享知识，共享智慧！知识，因分享，传承久远！

BookStack是基于[Mindoc](https://github.com/lifei6671/mindoc)开发的，为运营而生。

在开发的过程中，增加和移除了一些东西，目前已经不兼容MinDoc了（毕竟数据表结构、字段、索引都有了一些不同），同时只支持markdown编辑器。


<a name="open"></a>
## 开源
两年前还在做PHP开发的时候，无意间遇到了Gitbook，以及看云，还有readthedoc。

当时想着自己也开发一套，但是后来没时间，当时也没那个技术积累。

后来学了Go语言，又在无意间遇到了[Mindoc](https://github.com/lifei6671/mindoc)，然后我们公司([掘金量化](https://www.myquant.cn) )也恰巧让我开发公司官网和文档系统，然后我就对[Mindoc](https://github.com/lifei6671/mindoc)做了二次开发。

本来是不想开源的，因为自己写代码的时候，写着写着，代码改来改去，然后代码就乱七八糟了，怕开源出来丢人现眼。但是踏入IT行业三年多时间以来，自身也受益于各种开源项目和开源组件，所以最终还是决定将BookStack开源出来。

其中肯定还是有不足的地方，大家在使用的过程中，遇到问题，欢迎反馈。

源码托管：
- Gitee: https://gitee.com/xiaonian0430/BookStack

<a name="qqgroup"></a>
## QQ交流群
为方便相互学习和交流，建了个QQ群，加群请备注`来自BookStack`

> QQ交流群：457803862(猿军团)

同时要说明的是，该群是一个学习交流群，如果是程序相关问题，请直接提交issues，不接受邮件求助、微信求助和QQ私信求助

BookStack 安装使用手册：[https://www.bookstack.cn/books/help](https://www.bookstack.cn/books/help)


<a name="site"></a>
## 站点

<a name="demo"></a>
### 演示站点

> 服务器资源有限，不再提供演示站点

<a name="normal"></a>
### 正式站点

**书栈网**：[https://www.bookstack.cn](https://www.bookstack.cn)



<a name="upgrade"></a>
## 更新、维护和升级

- 程序下载与升级日志，看这里--> [Release](/truthhun/BookStack/releases)

<a name="func"></a>
## 功能与亮点

<a name="cate"></a>
### 书籍分类(V1.2 +)
用户就像你的老板，他不知道自己需要什么，但是他知道自己不需要什么...

<a name="homepage"></a>
### 用户主页(V1.2 +)
在用户主页，展示用户分享的书籍、粉丝、关注和手册，增加用户间的互动

<a name="import"></a>
### 一键导入markdown项目
这个功能，相信是很多人的最爱了。目前这个功能仅对管理员开放。
> 经实测，目前已完美支持各种姿势写作的markdown项目的文档导入，能很好地处理文档间的链接以及文档中的图片链接

![一键导入项目](static/openstatic/import.png)

<a name="pull"></a>
### 一键拉取markdown项目
看到GitHub、Gitee等有很多开源文档的项目，但是一个一个去拷贝粘贴里面的markdown内容不现实。于是，做了这个一键拉取的功能。
目前只有管理员才有权限拉取，并没有对普通用户开放。要体验这个功能，请用管理员账号登录演示站点体验。
用法很简单，比如我们拉取beego的文档项目，在创建项目后，直接点击"拉取项目"，粘贴如" https://github.com/beego/beedoc/archive/master.zip "，然后就会自动帮你拉取上面的所有markdown文档并录入数据库，同时图片也会自动帮你更新到OSS。
![拉取项目](static/openstatic/pull.png)
> 经实测，目前已完美支持各种姿势写作的markdown项目的拉取，能很好地处理文档间的链接以及文档中的图片链接

> 目前已支持Git Clone导入项目

<a name="generate"></a>
### 生成和导出PDF、epub、mobi等离线文档
这个需要安装和配置calibre。
我将calibre的使用专门封装成了一个工具，并编译成了二进制，源码、程序和使用说地址：[https://github.com/TruthHun/converter](https://github.com/TruthHun/converter)
在BookStack中，已经引入这个包了。使用的时候，点击"生成下载文档"即可

<a name="sort"></a>
### 文档排序和批量创建文档
很多时候，我们在写作文档项目的时候，会习惯地先把文档项目的章节目录结构创建出来，然后再慢慢写内容。
但是，文档项目中的文档少的时候，一个个去创建倒没什么，但是文档数量多了之后，简直就是虐待自己，排序的时候还要一个一个去拖拽进行排序，很麻烦。现在，这个问题已经解决了。如下：
- 在文档项目中，创建一个文档标识为`summary.md`的文档(大小写不敏感)
- 在文档中，填充无序列表的markdown内容，如：

```markdown
<bookstack-summary></bookstack-summary>
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
> 必须要有`<bookstack-summary></bookstack-summary>`，这样是为了告诉程序，我这个`summary.md`的文档，是用来创建文档和对文档进行排序的。当然，排序完成之后，当前页面会刷新一遍，并且把`<bookstack-summary></bookstack-summary>`移除了。有时候，第一次排序并没有排序成功，再添加一次这个标签，程序会自动帮你再排序一次。
> 我自己也常用这种方式批量创建文档以及批量修改文档的标题


<a name="redirect"></a>
### 文档间的跳转
你在一个文档项目中会有很多文档，其中一个文档的文档标识叫`readme.md`,另外一个文档的文档标识叫`quickstart.md`，两个文档间如何跳转呢？
如果你知道站点的路由规则，倒是可以轻松链过去，但是，每次都要这样写，真的很麻烦。自己也经常写文档，简直受够了，然后想到了一个办法。如下：
我从`readme.md`跳转到`quickstart.md`，在`readme.md`中的内容这样写:
``` 
[快速开始]($quickstart.md)
```
如果跳转到`quickstart.md`的某个锚点呢？那就像下面这样写：
``` 
[快速开始-步骤三]($quickstart.md#step3)
```
好了，在发布文档的时候，文档就会根据路由规则以及你的文档标识去生成链接了(由于是后端去处理，所以在编辑文档的时候，前端展示的预览内容，暂时是无法跳转的)。
那么，问题就来了，我文档项目里面的文档越来越多，我怎么知道我要链接的那个文档的文档标识呢？不用担心，在markdown编辑器的左侧，括号里面的红色文字显示的就是你的文档标识。

![文档标识](static/openstatic/identify.png)

<a name="crawl"></a>
### 采集功能
看到一篇很好的文章，但是文章里面有代码段、有图片，手工复制过来，格式全乱了，所以，相信采集功能，会是你需要的。采集功能，在markdown编辑器的功能栏上面，对，就是那个瓢虫图标，就是那个Bug，因为我找不到蜘蛛的图标...

功能见下图，具体体验，请到演示站点体验。

![采集](static/openstatic/crawl.png)


<a name="seo"></a>
### SEO
后台管理，个性化定制你的SEO关键字；并且在SEO管理这里，可以更新站点sitemap（暂时没做程序定时自动更新sitemap）


<a name="version-control"></a>
### 版本控制
`MinDoc`之前本身就有版本控制的，但是版本控制的文档内容全都存在数据库中，如果修改频繁而导致修改历史过多的话，数据库可能会被撑爆。当时没有好的解决办法，所以将该功能移除了。

目前加上该功能，是因为这个功能呼声很高，所以加回来了。但是版本控制的内容不再存储到数据库中，而是以文件的形式存储到本地或者是云存储上。

功能在`管理后台`->`配置管理`中进行开启

<a name="beauty"></a>
### 更美观、简洁的页面布局和更为完善的移动端兼容
这是个看脸的时代...

> 首页

![首页](static/openstatic/page-index.png)

> 介绍页

![介绍页](static/openstatic/page-intro.png)

> 内容阅读页

![内容阅读页](static/openstatic/page-read.png)

> 个人项目页

![个人项目页](static/openstatic/page-project.png)

> 手机端首页

![个人项目页](static/openstatic/page-mobile.png)


<a name="todo"></a>
## TODO
- 文档阅读书签
- 微信第三方登录
- 微博第三方登录
- 收费下载和收费阅读(放在最后开发)
- 签到功能
- 增加广告位和广告管理
- 积分功能
- 除了数据库配置项外，其余配置项尽可能在管理后台可配置
- 增强搜索功能，上elasticsearch
- 简化程序部署，上docker
- 微信小程序(放到2.x版本开发)
- 版本管理 ？(待找到更优解决方案了再实现)
- 使用weex开发手机端APP ? (vue.js熟练了再抽时间实现)
- 使用electron开发桌面端，实现类似网易`有道云笔记`的功能 ? (vue.js熟练了再抽时间实现)

Tips:
> 更多功能，期待您的想象力，然后通过issue向我提出来，或者到HC-CMS(http://www.hc-cms.com) 发帖提出


<a name="install"></a>
## 安装与使用


为了方便，安装和使用教程，请移步到这里：http://www.bookstack.cn/read/help/Ubuntu.md

> 目前只写了Ubuntu下的安装教程，Windows下的安装和使用教程，暂时没时间

有两个模板文件，需要手动修改下：
`/views/widgets/pdf_footer.html` 导出PDF文档时，pdf的footer显示内容
`/views/document/tpl_statement.html` 修改成你想要的文案内容或者删除该文件。如果保留该文件，必须要有`h1`标签，因为程序要提取你的`h1`标签用于导出文档的目录生成

默认的管理员账号密码均是`admin`

> `v1.0`升级到`v1.1`,直接下载对应系统的发行版本，然后根据配置文件的配置提示修改配置文件，然后覆盖升级即可。本次升级，没有改动数据库。

关于二次开发，请看这个issue [README.md中能否添源码编译说明](https://github.com/TruthHun/BookStack/issues/3)


<a name="aboutme"></a>
## 关于本人
2014年7月本科"毕业"踏入IT行业；Web全栈工程师；什么都懂一点，什么都不精通。


<a name="support"></a>
## 赞助我
如果我的努力值得你的肯定，请赞助我，让我在开源的路上，做更好，走更远。
赞助我的方式包括：`支付宝打赏`、`微信打赏`、`给BookStack一个star`、`向我反馈意见和建议`


<a name="alipay"></a>
### 支付宝打赏赞助
![支付宝打赏赞助](static/openstatic/alipay.jpg)

<a name="wxpay"></a>
### 微信打赏赞助
![微信打赏赞助](static/openstatic/wxpay.jpg)


