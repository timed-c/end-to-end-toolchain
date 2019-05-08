#!/bin/bash
name=$1
../ktc/bin/ktc --gcc=arm-linux-gnueabihf-gcc  --rasp --enable-ext2 --save-temps $name -I. -L. -lplogsrasp -lmbenchrasp -w
