#!/bin/bash
new_branch(){
  git checkout master
  git reset --hard
  git clean -dfx
  git checkout -b $branch

}
new_branch
