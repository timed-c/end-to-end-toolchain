#!/bin/bash
name=$1
k=$2
iter=$3
rm -f *.ktc.trace
rm -f *_mk
rm -f *.dot
rm -f a.out
../ktc/bin/ktc --enable-ext4 $name --save-temps -g -I. -L. -lmplogs -lqsort -lbasicmath -lbitcount -lm -w --link
sudo ./a.out $2 $3
