 #include <stdio.h> 
 #include <math.h> 
 #include <stdlib.h> 
 #include "cilktc.h" 
 #include "mbench.h" 

 
 FILE dfile;

 
task tsk_0(){
	 	 spriority(6);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(7);
	 	 fdelay(40,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(5);
	 	 fdelay(30,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(6);
	 	 sdelay(50,ms);
	 } 
}
 
task tsk_1(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(7);
	 	 sdelay(20,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(8);
	 	 fdelay(30,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(8);
	 	 fdelay(20,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(6);
	 	 fdelay(20,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(8);
	 	 fdelay(40,ms);
	 } 
}
 
task tsk_2(){
	 	 spriority(5);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(5);
	 	 sdelay(50,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(9);
	 	 sdelay(50,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(9);
	 	 fdelay(10,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(8);
	 	 sdelay(10,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(5);
	 	 fdelay(20,ms);
	 } 
}
 
task tsk_3(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(6);
	 	 fdelay(30,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(7);
	 	 sdelay(40,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(7);
	 	 fdelay(30,ms);
	 } 
}
 
task tsk_4(){
	 	 spriority(6);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_400.dat");
	 	 spriority(7);
	 	 fdelay(40,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(5);
	 	 fdelay(30,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(8);
	 	 sdelay(50,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(6);
	 	 fdelay(20,ms);
	 } 
}
 int main(int argc, char* argv[]){
	 tsk_0();
	 tsk_1();
	 tsk_2();
	 tsk_3();
	 tsk_4();
}