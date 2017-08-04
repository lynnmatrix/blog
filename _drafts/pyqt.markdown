---
layout: "post"
title: "准备PyQt开发环境"
date: "2016-12-12 17:38"
---

安装PyQt时出现“Operation not permitted”无法安装, 原因：
经历了XCode编译器代码被注入的事件后，Mac OS X El Capitan系统的升级，启用了更高的安全性保护机制：系统完整性保护System Integrity Protection (SIP)。简单来讲就是更加强制性的保护系统相关的文件夹。开发者不能直接操作相关的文件内容。
http://blog.luoyuanhang.com/2016/04/06/%E8%A7%A3%E5%86%B3-Mac-OS-X-10-11-%E5%AE%89%E8%A3%85-sip-%E6%B2%A1%E6%9C%89%E6%9D%83%E9%99%90%E7%9A%84%E9%97%AE%E9%A2%98/

解决方案：
1. brew install python (Recommended)
2. csrutil disable

virtualenv --no-site-packages -p /usr/local/Cellar/python/2.7.12_2/bin/python ENV_house
