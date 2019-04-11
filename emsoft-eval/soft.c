/*tasks with periodic loop*/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "cilktc.h"
#include "log.h"
#include "snipmath.h"

void qsort_large();
void qsort_small();
void mdeg2rad(int k);
void mrad2deg(int k);
void mSolveCubic(int k);
void musqrt(int k);


task tsk_1(){
    stp(0, infty, ms);
    while(1){
    musqrt(2);
    sdelay(1000, ms);
    }
}

task tsk_2(){
    stp(0, infty, ms);
    while(1){
    mdeg2rad(1);
    sdelay(500, ms);
    }
}

task tsk_3(){
    stp(0, infty, ms);
    while(1){
    mrad2deg(1);
    sdelay(50, ms);
    }
}

task tsk_4(){
    stp(0, infty, ms);
    while(1){
    mSolveCubic(1);
    sdelay(100, ms);
    }
}

task tsk_5(){
    stp(0, infty, ms);
    while(1){
    musqrt(1);
    sdelay(200, ms);
    }
}

task tsk_6(){
    stp(0, infty, ms);
    while(1){
    musqrt(0);
    sdelay(10, ms);
    }
}

task tsk_7(){
    stp(0, infty, ms);
    while(1){
    mdeg2rad(0);
    sdelay(500, ms);
    }
}

task tsk_8(){
    stp(0, infty, ms);
    while(1){
    mrad2deg(1);
    sdelay(300, ms);
    }
}

task tsk_9(){
    stp(0, infty, ms);
    while(1){
    mSolveCubic(1);
    sdelay(250, ms);
    }
}

task tsk_10(){
    stp(0, infty, ms);
    while(1){
    musqrt(2);
    sdelay(125, ms);
    }
}

int main(){
    long unsigned int targ = 10;
    tsk_1();
    tsk_2();
    tsk_3();
    tsk_4();
    tsk_5();
    tsk_6();
    tsk_7();
    tsk_8();
    tsk_9();
    tsk_10();
    printf("main--end\n");
}
