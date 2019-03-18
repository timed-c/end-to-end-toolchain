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
        mrad2deg(5);
        sdelay(100, ms);
    }
}


task tsk_b(){

    int i;
    for(i=0; i<50;i++){
        basicmath_small();
        sdelay(100, ms);
    }

}




int main(){
    long unsigned int targ = 10;
    tsk_a();
    tsk_b();
    printf("main--end\n");
}
