#!/bin/bash

hostname $container

mkdir -p /sys/fs/cgroup/memory/$container
echo $$ > /sys/fs/cgroup/memory/$container/cgroup.procs
echo $memory > /sys/fs/cgroup/memory/$container/memory.limit_in_bytes

mkdir -p $container/rwlayer
mount -t aufs -o dirs=$container/rwlayer:./images/$image none $container

mkdir -p $container/old_root
cd $container

mount --make-rprivate /

pivot_root . ./old_root

# proc
mkdir /proc && echo "/proc create success" || echo "/proc fs maybe fail"
mount -t proc proc /proc

# /sys
mkdir /sys && echo "/sys create success" || echo "/sys fs maybe fail"
mount -t sysfs sys /sys

# /dev
# mount -t tmpfs tmpfs /dev



umount -l /old_root

if test "$network" = bridge; then
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
fi

exec $program