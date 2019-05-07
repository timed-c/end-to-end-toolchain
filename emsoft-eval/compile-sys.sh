#!/bin/bash
name=$1
../ktc/bin/ktc  --enable-ext4 --save-temps $name -g -I. -L. -lmplogs -lmbench -w --link
