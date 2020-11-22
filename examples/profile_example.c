/*tasks with periodic loop*/
#include <stdio.h>
#include <stdlib.h>
#include <cilktc.h>


FILE dfile;


void fun() {
    int i;
    for(i=0; i<1000; i++){}
}


task tsk_foo(){
    stp(0, infty, ms);
    while(1){
        fun();
        sdelay(30, ms);

    }
}


task tsk_bar(){
    stp(0, infty, ms);
    while(1){
        fun();
        sdelay(20, ms);

    }

}

task tsk_boo(){
    stp(0, infty, ms);
    while(1){
        sdelay(10, ms);
    }
}




int main(int argc, char* argv[]){
    long unsigned int targ = 10;
    tsk_foo();
    tsk_bar();
    tsk_boo();
    printf("main--end\n");
}
