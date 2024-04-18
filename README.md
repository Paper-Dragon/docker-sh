# mini_bash

```bash
/lib/terminfo/x/xterm:/lib/terminfo/x/xterm
[root@k8s-master:~/bash-rootfs]# ldd */*/*
lib/terminfo/x:
ldd: lib/terminfo/x: not regular file
lib/x86_64-linux-gnu/libc-2.31.so:
        /lib64/ld-linux-x86-64.so.2 (0x00007f095b3dd000)
        linux-vdso.so.1 (0x00007ffd18dad000)
lib/x86_64-linux-gnu/libc.so.6:
        /lib64/ld-linux-x86-64.so.2 (0x00007f5b66c6e000)
        linux-vdso.so.1 (0x00007ffe385fc000)
lib/x86_64-linux-gnu/libdl-2.31.so:
        linux-vdso.so.1 (0x00007ffeaf278000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fafd2433000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fafd2634000)
lib/x86_64-linux-gnu/libdl.so.2:
        linux-vdso.so.1 (0x00007fff1b3f6000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f6332566000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f6332767000)
lib/x86_64-linux-gnu/libtinfo.so.6:
        linux-vdso.so.1 (0x00007ffd91d81000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fa907fe9000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fa908214000)
lib/x86_64-linux-gnu/libtinfo.so.6.2:
        linux-vdso.so.1 (0x00007ffe46d77000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f461ee4c000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f461f077000)
usr/bin/bash:
        linux-vdso.so.1 (0x00007ffd49df6000)
        libtinfo.so.6 => /lib/x86_64-linux-gnu/libtinfo.so.6 (0x00007fd3a5d24000)
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fd3a5d1e000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fd3a5b2c000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fd3a5e89000)
[root@k8s-master:~/bash-rootfs]# docker run -it --rm  jockerdragon/bash:5.0 bash
[I have no name!@d3af07f8866b /]#
[I have no name!@d3af07f8866b /]#
[root@k8s-master:~/bash-rootfs]# tar -cvf ../bash.tar *
bin/
bin/bash
etc/
etc/bash.bashrc
lib/
lib/x86_64-linux-gnu/
lib/x86_64-linux-gnu/libc-2.31.so
lib/x86_64-linux-gnu/libtinfo.so.6
lib/x86_64-linux-gnu/libdl-2.31.so
lib/x86_64-linux-gnu/libtinfo.so.6.2
lib/x86_64-linux-gnu/libdl.so.2
lib/x86_64-linux-gnu/libc.so.6
lib/terminfo/
lib/terminfo/x/
lib/terminfo/x/xterm
lib64/
lib64/ld-linux-x86-64.so.2
usr/
usr/bin/
usr/bin/bash
[root@k8s-master:~/bash-rootfs]# docker import ../bash.tar
sha256:dfdc13f29846288fc47e830dd687e28978efc1fbf7888165a7fbf72560dcacbc
[root@k8s-master:~/bash-rootfs]#




```
