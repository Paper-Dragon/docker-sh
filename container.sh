#!/bin/bash

# 定义字体颜色
Green="\033[32m"
Red="\033[31m"
#Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
YellowBG="\033[43;37m"
Font="\033[0m"

# 定义通知信息
Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"
Warning="${Red}[警告]${Font}"
Debug="${Green}[调试]${Font}"


# 判断操作是否成功
judge() {
  if [[ 0 -eq $? ]]; then
    echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
    sleep 0.5
  else
    echo -e "${Error} ${RedBG} $1 失败${Font}"
    exit 1
  fi
}

# ========================================================== #
configure_network_bridge() {
	while true
	do
		ip link show veth1-$container
		if test $? != 0; then
			sleep 1
		else
			break
		fi
	done

	ip addr add $addr/24 dev veth1-$container
	ip link set dev veth1-$container up
	ip route add default via 172.31.0.1 dev veth1-$container

}

set_container_hostname() {
    hostname "$container"
    judge "给容器设置主机名为 ${container}"
}

set_container_hostname

prepare_container_tor_filesystem() {
	mkdir -p ${PWD}/$container/rwlayer
	judge "创建rwlayer目录"

	# 尝试挂载aufs文件系统
	judge "${Debug} 尝试使用 aufs挂载"

	if mount -t aufs -o dirs="$container/rwlayer:./images/$image" none "$container"; then
        echo -e "${Debug} 使用aufs挂载成功"
	# 尝试挂载overlay文件系统
    else
		echo -e "${Warning} Aufs创建失败 切换为overlay模式${Font}"
		mkdir -p "$container/upperdir" "$container/workdir"
        judge "创建overlay所需的upperdir和workdir目录"

		mount -t overlay -o lowerdir=${PWD}/images/$image,upperdir=${PWD}/$container/upperdir,workdir=${PWD}/$container/workdir overlay $container
		ls $container
		if [ $? -eq 0 ] ; then
			echo -e "${Debug} mount -t overlay -o lowerdir=${PWD}/images/$image,upperdir=${PWD}/$container/upperdir,workdir=${PWD}/$container/workdir overlay $container"
        	echo -e "${Debug} 使用overlay挂载成功"
    	else
			echo -e "${Error} 挂载文件系统失败，无法使用aufs或overlay"
			exit 1
		fi
    fi
	
}

prepare_container_tor_filesystem


mkdir -p $container/old_root
judge "创建root fd 转换"

cd $container
mount --make-rprivate /
judge "设置根fd私有化"

pivot_root . ./old_root


exec chroot . sh -c '
    # 重置PATH，确保能找到基本命令
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    # 重新挂载/proc, /sys, /dev等
    mount -t proc proc /proc
    mount -t sysfs sys /sys
    mount -t tmpfs tmpfs /dev
    # 其他初始化操作...
    # 最终执行你的程序
    exec '"$program"'
'

# # umount -l /old_root
# # # 网络配置示例（针对桥接模式）

# # if test "$network" = bridge; then
# # 	configure_network_bridge
# # fi

# exec $program