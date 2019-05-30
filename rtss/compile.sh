#!/bin/bash
name=$1
rm -f a.out
../ktc/bin/ktc --gcc=arm-linux-gnueabihf-gcc  --enable-ext4 --rasp --save-temps $name -lrt -I. -L. -lraspmplogs -lraspbasicmath -lraspbitcount -lm -w --link
scp a.out pi@10.42.0.101:/home/pi/Documents/rtss


