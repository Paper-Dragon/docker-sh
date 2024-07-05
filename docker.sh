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
        sleep 0.1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}

# 显示使用说明
usage() {
    echo -e "\n${RedBG} 注意：请以root身份运行 ${Font}\n"
    echo -e "${GreenBG}[ 用 法 ]${Font}: docker.sh [OPTIONS]"
    
    echo -e "\n${GreenBG}选 项:${Font}"
    echo "-m 内存限制, 如：100M, 200M"
    echo "-C 容器名称"
    echo "-I 镜像名称"
    echo "-P 容器内运行的程序"
    echo "-n 网络模式 [host|none|bridge]"
    
    echo -e "\n${GreenBG} 示例:${Font}"
    echo -e "${YellowBG}git clone --single-branch -b alpine-3.17.3  https://github.com/Paper-Dragon/docker-sh images/alpine-3.17.3${Font}"
    echo -e "${YellowBG}docker.sh -m 100M -C alpine-3.17.3 -I alpine-3.17.3 -P /bin/bash -n host${Font}\n"
    exit 0
}

is_root() {
    if [ 0 == $UID ]; then
        echo -e "${OK} ${GreenBG} 当前用户是root用户，进入创建流程 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} 当前用户不是root用户，请切换到root用户后重新执行脚本 ${Font}"
        exit 1
    fi
}

# 准备容器cgroup
prepare_container_resource_limit() {
    echo -e "${Debug}子进程ID: $$ ${Font}"
    echo -e "${Debug}父进程ID: $PPID ${Font}"
    mkdir -p /sys/fs/cgroup/memory/$container
    judge "创建内存cgroup"
    
    echo $$ > /sys/fs/cgroup/memory/$container/cgroup.procs
    judge "对进程 $$ 进行资源限制"
    
    echo $memory > /sys/fs/cgroup/memory/$container/memory.limit_in_bytes
    if [[ 0 -ne $? ]]; then
        echo -e "${Error} ${RedBG} 设置限制内存大小为 ${memory} 失败${Font}"
    fi
}

# 网络配置
configure_network() {
    case $network in
        host)
            judge "配置Host网络"
            judge "创建名称空间"
            prepare_container_resource_limit
            unshare --uts --mount --pid --fork ./container.sh
        ;;
        none)
            judge "配置None网络"
            if [ -e /var/run/netns/$container ]; then
                echo "${Error} 网络命名空间已存在: $container"
                exit 1
            fi
            prepare_container_resource_limit
            touch /var/run/netns/$container
            unshare --uts --mount --pid --net=/var/run/netns/$container --fork ./container.sh
        ;;
        bridge)
            judge "配置Bridge网络"
            if [ -e /var/run/netns/$container ]; then
                prepare_container_resource_limit
                echo Abort: netns $container exists
                exit -1
            fi
            
            touch /var/run/netns/$container
            
            ip link add veth1-$container type veth peer name veth2-$container
            ip link set dev veth2-$container master dockersh0
            ip link set dev veth2-$container up
            
            ./set_netns.sh veth1-$container $container &
            
            addr=unknown
            for i in {2..254}
            do
                ping -c 3 172.31.0.$i;
                
                if test $? != 0; then
                    export addr=172.31.0.$i
                    
                    break
                fi
            done
            unshare --uts --mount --pid --net=/var/run/netns/$container --fork ./container.sh
        ;;
        *)
            echo "${Error} 不支持的网络模式: $network"
            exit 1
        ;;
    esac
}


# 主程序
main() {
    export memory=""
    export container=""
    export image=""
    export program=""
    export network="bridge"
    
    
    while getopts m:C:I:V:P:n: option; do
        case $option in
            m) export memory=$OPTARG ;;
            C) export container=$OPTARG ;;
            # V) export volume=$OPTARG;; # Furture
            I) export image=$OPTARG ;;
            P) export program=$OPTARG ;;
            n) export network=$OPTARG ;;
            *) export usage ;;
        esac
    done
    
    
    
    # 必须参数检查
    [[ -z $container || -z $image ]] && usage
    
    is_root
    configure_network
    
}

main $@