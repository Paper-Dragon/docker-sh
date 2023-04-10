#!/bin/bash
new_rootfs(){
  docker export $(docker create "$image") | tar -C . -xvf -
}
image=$1
new_rootfs
