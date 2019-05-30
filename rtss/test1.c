 #include <stdio.h>
 #include <math.h>
 #include <stdlib.h>
 #include "cilktc.h"
 #include "mbench.h"


FILE dfile;

int call_fun(int x){
    int i;
    for(i=0; i<x; i++){
        basicmath_small();
    }
}

int call_while(){
    while(1){}
}

task task1(){
    stp(0, infty, ms);
    while(1){
        sdelay(50, ms);
        call_fun(1);
        sdelay(100, ms);
    }
}

task task2(){
    stp(0, infty, ms);
    while(1){
        call_fun(1);
        sdelay(100, ms);
    }
}




int main(int argc, char* argv[]){
    task1();
    task2();
    printf("main--end\n");
}
