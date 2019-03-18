/*tasks with periodic loop*/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "cilktc.h"
#include "log.h"
#include "snipmath.h"



FILE dfile;

void qsort_large();
void qsort_small();
void mdeg2rad(int k);
void mrad2deg(int k);
void mSolveCubic(int k);
void musqrt(int k);

task tsk_foo(){
    int i;
    for(i=0;i<50;i++){
        mrad2deg(50);
        sdelay(300, ms);
    }
}


task tsk_bar(){

    int i =0;
        while(i < 50){
        basicmath_small();
        sdelay(200, ms);
        i++;
    }

}


task tsk_far(){
    int i;
    for(i=0; i<50;i++){
         rad2deg(100);
        sdelay(600, ms);
    }
}



int main(){
    long unsigned int targ = 10;
    tsk_foo();
    tsk_bar();
    tsk_far();
    printf("main--end\n");
}
