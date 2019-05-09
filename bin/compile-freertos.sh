#!/bin/bash
name=$1
../ktc/bin/ktc --enable-ext1 --save-temps $name -I. -L. -w
