 #include <stdio.h>
 #include <math.h>
 #include <stdlib.h>
 #include "cilktc.h"
 #include "mbench.h"


 FILE dfile;
void func(int x){
 	 int i;
 	 for(i=0; i<x; i++){
 	 	 mbitcount(50);}
}

task tsk_0(){
	 	 spriority(20);
	 stp(0, infty, ms);
	 while(1){
	 	 func(1000);
	 	 spriority(20);
	 	 sdelay(20,ms);
	 }
}

task tsk_1(){
	 	 spriority(100);
	 stp(0, infty, ms);
	 while(1){
	 	 func(1);
	 	 spriority(100);
	 	 sdelay(100,ms);
	 }
}
 int main(int argc, char* argv[]){
	 tsk_0();
	 tsk_1();
}
