#!/bin/bash
file=$1
sudo ../../bin/ktc $file --posix --timing-param 4 100
arm-linux-gnueabihf-gcc  $cilfile -I../ -L../ -lraspmplogs -lraspcrc -lraspbitcount -lraspbasicmath -lraspqsort -lpthread -lktcrasp -lm -lrt -w
ssh pi@10.42.0.101 "cd && cd /home/pi/Documents/rtss/ && ./clean.sh && sudo ./a.out 4 10 && scp *.ktc.trace saranya@10.42.0.1:/home/saranya/Dokument/e2e/rtss/ && ./clean.sh && exit"

