# Docker命令行版

## 介绍
一些操作系统的rootfs，从Docker Image 中导出。
主要作用是脱离docker容器软件手工创建容器。


## 手工创建
- 过程是 [change_rootfs.sh](change_rootfs.sh)

## docker.sh
> 一些代码 fork from [docker.sh](https://github.com/pandengyang/docker.sh) ，bug修复版本。

### 功能

docker.sh 是用 Shell 写的一个简易的 docker，支持以下功能：

* uts namespace
* mount namespace
* pid namespace
* memory 资源限制
* 联合加载
* 卷目录
* network namespace
* iptables
* volume [Furture]
* 前台、后台运行 [Furture]

### 运行容器

```bash
# 克隆所需rootfs
git clone --single-branch -b alpine-3.17.3  https://github.com/Paper-Dragon/rootfs images/alpine-3.17.3


chmod +x *.sh

# ./docker.sh -m 容器内存大小 -C 容器名称 -I 镜像名称【需要与分支名一致】 -P /bin/bash -n none
./docker.sh -m 100M -C alpine-3.17.3 -I alpine-3.17.3 -P /bin/bash -n host
```





## 仓库中包含的Rootfs 
- Alpine 3.17.3
- BusyBox 1.36.0
- docker 23.0.3
- Fedora 36
- Fedora 39
- RockyLinux 9.1
- Ubuntu 23.04

