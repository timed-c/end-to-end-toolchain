 #include <stdio.h> 
 #include <math.h> 
 #include <stdlib.h> 
 #include "cilktc.h" 
 #include "mbench.h" 

 
 FILE dfile;

 
task tsk_0(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(8);
	 	 fdelay(30,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(7);
	 	 fdelay(20,ms);
	 } 
}
 
task tsk_1(){
	 	 spriority(5);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(8);
	 	 fdelay(50,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(5);
	 	 sdelay(20,ms);
	 } 
}
 
task tsk_2(){
	 	 spriority(9);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_400.dat");
	 	 spriority(6);
	 	 fdelay(10,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(9);
	 	 sdelay(40,ms);
	 } 
}
 
task tsk_3(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(6);
	 	 fdelay(30,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(7);
	 	 sdelay(40,ms);
	 } 
}
 
task tsk_4(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_400.dat");
	 	 spriority(5);
	 	 sdelay(20,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(9);
	 	 fdelay(50,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(8);
	 	 sdelay(10,ms);
	 } 
}
 
task tsk_5(){
	 	 spriority(9);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(6);
	 	 fdelay(10,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(9);
	 	 sdelay(40,ms);
	 } 
}
 
task tsk_6(){
	 	 spriority(9);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_400.dat");
	 	 spriority(9);
	 	 sdelay(10,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(9);
	 	 sdelay(10,ms);
	 } 
}
 
task tsk_7(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(7);
	 	 sdelay(30,ms);
	 } 
}
 
task tsk_8(){
	 	 spriority(5);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(9);
	 	 fdelay(50,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(9);
	 	 sdelay(10,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(5);
	 	 fdelay(10,ms);
	 } 
}
 
task tsk_9(){
	 	 spriority(6);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(7);
	 	 sdelay(40,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(6);
	 	 fdelay(30,ms);
	 } 
}
 int main(int argc, char* argv[]){
	 tsk_0();
	 tsk_1();
	 tsk_2();
	 tsk_3();
	 tsk_4();
	 tsk_5();
	 tsk_6();
	 tsk_7();
	 tsk_8();
	 tsk_9();
}