/*tasks with periodic loop*/
#include <stdio.h>
#include <stdlib.h>
#include <cilktc.h>
#include "nsichneu.c"

FILE dfile;


task tsk_foo(){
    stp(0, infty, ms);
    while(1){
		nsicherneu();
        hdelay(20, ms);
    }
}


task tsk_boo(){
    stp(0, infty, ms);
    while(1){
		nsicherneu();
        sdelay(10, ms);
    }
}

int main(int argc, char* argv[]){
    long unsigned int targ = 10;
    tsk_foo();
	tsk_boo();
    
}
