---
title: "install gitlab"
date: "2017-02-04 14:06"
author: 林以明
comments: true
---
https://about.gitlab.com/downloads/#ubuntu1604
![gitlab 502](../images/gitlab-502.png)
sudo chmod -R o+x /var/opt/gitlab/gitlab-rails


sudo usermod -aG gitlab-www www-data
或者
web_server['external_users'] = ['www-data']
