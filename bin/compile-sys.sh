#!/bin/bash
name=$1
../ktc/bin/ktc  --enable-ext4 --save-temps $name -I. -L. -lplogs -lmbench -w
