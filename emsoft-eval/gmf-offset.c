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
    stp(1,infty, ms);
    while(1){
    mrad2deg(2);
    sdelay(50, ms);
    mrad2deg(1);
    fdelay(50, ms);
    }
}

task tsk_2(){
    stp(2,infty, ms);
    while(1){
    mdeg2rad(1);
    sdelay(500, ms);
    mdeg2rad(1);
    fdelay(200, ms);
    mdeg2rad(1);
    sdelay(100, ms);
    }
}

task tsk_5(){
    stp(10,infty, ms);
    while(1){
    musqrt(1);
    sdelay(500, ms);
    musqrt(1);
    sdelay(1000, ms);
    }
}

task tsk_10(){
    stp(0, infty, ms);
    while(1){
    musqrt(0);
    sdelay(100, ms);
    }
}

/*
task tsk_20(){
    stp(1, infty, ms);
    while(1){
    sdelay(10, ms);
    musqrt(0);
    fdelay(100, ms);
    }
}

task tsk_50(){
    stp(200,infty, ms);
    while(1){
    mSolveCubic(1);
    sdelay(500, ms);
    mSolveCubic(1);
    sdelay(100, ms);
    }
}

task tsk_100(){
    stp(500, infty, ms);
    int i;
    while(1){
    sdelay(100, ms);
    sdelay(200, ms);
    }
}

task tsk_200(){
    stp(0,infty, ms);
    while(1){
    musqrt(0);
    sdelay(200, ms);
    }
}
*/




int main(){
    long unsigned int targ = 10;
    tsk_1();
    tsk_2();
    tsk_5();
    tsk_10();
    /*tsk_20();
    tsk_50();
    tsk_100();
    tsk_200();*/
    printf("main--end\n");
}
