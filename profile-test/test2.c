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

FILE dfile;

task tsk_a(){
    int i;
    for(i=0;i<50;i++){
       // mrad2deg(50);
        sdelay(10, ms);
    }
}


task tsk_b(){

    int i;
    for(i=0; i<50;i++){
       // basicmath_small();
        sdelay(20, ms);
    }

}


task tsk_c(){
    int i;
    for(i=0; i<50;i++){
        // rad2deg(100);
        sdelay(30, ms);
    }
}

task tsk_d(){
    int i;
    for(i=0;i<50;i++){
       // mrad2deg(50);
        sdelay(40, ms);
    }
}


task tsk_e(){

    int i;
    for(i=0; i<50;i++){
       // basicmath_small();
        sdelay(50, ms);
    }

}


task tsk_f(){
    int i;
    for(i=0; i<50;i++){
        // rad2deg(100);
        sdelay(60, ms);
    }
}


int main(){
    long unsigned int targ = 10;
    tsk_a();
    tsk_b();
    tsk_c();
    tsk_d();
    tsk_e();
    tsk_f();
    printf("main--end\n");
}
