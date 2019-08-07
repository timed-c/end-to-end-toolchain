 #include <stdio.h> 
 #include <math.h> 
 #include <stdlib.h> 
 #include "cilktc.h" 
 #include "mbench.h" 

 
 FILE dfile;

 
task tsk_0(){
	 	 spriority(5);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(9);
	 	 sdelay(50,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(7);
	 	 sdelay(10,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(8);
	 	 sdelay(30,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(5);
	 	 sdelay(20,ms);
	 } 
}
 
task tsk_1(){
	 	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(7);
	 	 sdelay(100,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(4);
	 	 sdelay(30,ms);
	 } 
}
 
task tsk_2(){
	 	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(8);
	 	 sdelay(100,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(4);
	 	 sdelay(20,ms);
	 } 
}
 
task tsk_3(){
	 	 spriority(6);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(9);
	 	 sdelay(40,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(8);
	 	 sdelay(10,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(4);
	 	 sdelay(20,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(6);
	 	 sdelay(100,ms);
	 } 
}
 
task tsk_4(){
	 	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(4);
	 	 sdelay(100,ms);
	 } 
}
 
task tsk_5(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(7);
	 	 sdelay(20,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(5);
	 	 sdelay(30,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(8);
	 	 sdelay(50,ms);
	 } 
}
 
task tsk_6(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(7);
	 	 sdelay(30,ms);
	 } 
}
 
task tsk_7(){
	 	 spriority(5);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(4);
	 	 sdelay(50,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(5);
	 	 sdelay(100,ms);
	 } 
}
 
task tsk_8(){
	 	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(4);
	 	 sdelay(100,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(4);
	 	 sdelay(100,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(4);
	 	 sdelay(100,ms);
	 } 
}
 
task tsk_9(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(6);
	 	 sdelay(20,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(4);
	 	 sdelay(40,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(4);
	 	 sdelay(100,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(8);
	 	 sdelay(100,ms);
	 } 
}
 
task tsk_10(){
	 	 spriority(9);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(6);
	 	 sdelay(10,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(6);
	 	 sdelay(40,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(7);
	 	 sdelay(40,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(9);
	 	 sdelay(30,ms);
	 } 
}
 
task tsk_11(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(8);
	 	 sdelay(30,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(7);
	 	 sdelay(20,ms);
	 } 
}
 
task tsk_12(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(4);
	 	 sdelay(20,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(8);
	 	 sdelay(100,ms);
	 } 
}
 
task tsk_13(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(8);
	 	 sdelay(20,ms);
	 } 
}
 
task tsk_14(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(5);
	 	 sdelay(20,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(8);
	 	 sdelay(50,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(7);
	 	 sdelay(20,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(8);
	 	 sdelay(30,ms);
	 } 
}
 
task tsk_15(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(5);
	 	 sdelay(20,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(4);
	 	 sdelay(50,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(8);
	 	 sdelay(100,ms);
	 } 
}
 
task tsk_16(){
	 	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(7);
	 	 sdelay(100,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(4);
	 	 sdelay(30,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(4);
	 	 sdelay(100,ms);
	 } 
}
 
task tsk_17(){
	 	 spriority(6);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(4);
	 	 sdelay(40,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(6);
	 	 sdelay(100,ms);
	 } 
}
 
task tsk_18(){
	 	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(6);
	 	 sdelay(100,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(4);
	 	 sdelay(40,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(6);
	 	 sdelay(100,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(4);
	 	 sdelay(40,ms);
	 } 
}
 
task tsk_19(){
	 	 spriority(5);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(9);
	 	 sdelay(50,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(5);
	 	 sdelay(10,ms);
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
	 tsk_10();
	 tsk_11();
	 tsk_12();
	 tsk_13();
	 tsk_14();
	 tsk_15();
	 tsk_16();
	 tsk_17();
	 tsk_18();
	 tsk_19();
}