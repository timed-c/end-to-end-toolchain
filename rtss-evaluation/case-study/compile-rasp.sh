#!/bin/bash
rm traces/*
sudo ../../bin/ktc uav-lv.c --posix --timing-param 3 200
arm-linux-gnueabihf-gcc  uav-lv.cil.c -I../ -L../ -lraspmplogs -lraspcrc -lraspbitcount -lraspbasicmath -lraspqsort -lpthread -lktcrasp -lm -lrt -w -o uav
scp uav pi@10.42.0.101:/home/pi/Documents/rtss
ssh pi@10.42.0.101 "cd && cd /home/pi/Documents/rtss/ && ./clean.sh && sudo ./uav 3 200 && scp *.ktc.trace saranya@10.42.0.1:/home/saranya/Dokument/e2e-orgin/end-to-end-toolchain/rtss-evaluation/case-study/traces && ./clean.sh && exit"
