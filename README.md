# rootfs

## 介绍
一些操作系统的rootfs，从Docker Image 中导出。
主要作用是脱离docker容器软件手工创建容器。


## 手工创建
- 过程是 [change_rootfs.sh](change_rootfs.sh)

## docker.sh
> modify from [docker.sh](https://github.com/pandengyang/docker.sh) ，功能

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
* 前台后台运行 [Furture]

### 运行容器

```bash
./docker.sh -m 100M -C dreamland -I ubuntu1604 -P /bin/bash -n host -n none
```





## 仓库中包含的Rootfs 
- Alpine 3.17.3
- BusyBox 1.36.0
- docker 23.0.3
- Fedora 36
- Fedora 39
- RockyLinux 9.1
- Ubuntu 23.04

