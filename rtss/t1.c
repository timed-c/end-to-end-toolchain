/*tasks with periodic loop*/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <cilktc.h>

//void qsort_large();
//void qsort_small();
void mdeg2rad(int k);
void mrad2deg(int k);
void mSolveCubic(int k);
void musqrt(int k);

FILE dfile;
int call_fun(int x){
    int i;
    for(i=0; i<x; i++){
        basicmath_small();
    }
}

int call_fun2(int x){
    printf("call_fun2\n");
    while(1){}
}

int call_fun3(){
    int i;
    for(i=0; i<10000000;i++){}
    printf("call_fun3\n");
}


task task1(){
    int i=0;
    stp(0, infty, ms);
    while(1){
        printf("task1 fdelay\n");
        call_fun2(3);
        fdelay(20, ms);
        call_fun(1);
        printf("task1 sdelay\n");
        sdelay(50, ms);
        call_fun2(4);
        printf("task1 2nd fdelay\n");
        fdelay(50, ms);
    }
}

task task2(){
    int i=0;
    stp(0, infty, ms);
    while(1){
        printf("task2\n");
        call_fun3();
        fdelay(10, ms);
    }
}


int main(int argc, char* argv[]){
   // task1();
    task2();
    printf("main--end\n");

}
