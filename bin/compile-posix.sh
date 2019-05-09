#!/bin/bash
name=$1
../ktc/bin/ktc --enable-ext2 --save-temps $name -I. -L. -w
