 #include <stdio.h> 
 #include <math.h> 
 #include <stdlib.h> 
 #include "cilktc.h" 
 #include "mbench.h" 

 
 FILE dfile;

 
task tsk_0(){
	 	 spriority(9);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(3);
	 	 sdelay(10,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(2);
	 	 sdelay(200,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(1);
	 	 sdelay(500,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(7);
	 	 sdelay(1000,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(9);
	 	 sdelay(30,ms);
	 } 
}
 
task tsk_1(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(7);
	 	 sdelay(30,ms);
	 } 
}
 
task tsk_2(){
	 	 spriority(9);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(9);
	 	 sdelay(10,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(9);
	 	 sdelay(10,ms);
	 } 
}
 
task tsk_3(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(7);
	 	 sdelay(30,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(2);
	 	 sdelay(30,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(1);
	 	 sdelay(500,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(7);
	 	 sdelay(1000,ms);
	 } 
}
 
task tsk_4(){
	 	 spriority(5);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(5);
	 	 sdelay(50,ms);
	 } 
}
 
task tsk_5(){
	 	 spriority(3);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_400.dat");
	 	 spriority(3);
	 	 sdelay(200,ms);
	 } 
}
 
task tsk_6(){
	 	 spriority(1);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(4);
	 	 sdelay(1000,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(5);
	 	 sdelay(100,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(3);
	 	 sdelay(50,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(1);
	 	 sdelay(200,ms);
	 } 
}
 
task tsk_7(){
	 	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(5);
	 	 sdelay(100,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(6);
	 	 sdelay(50,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(5);
	 	 sdelay(40,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(4);
	 	 sdelay(50,ms);
	 } 
}
 
task tsk_8(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(4);
	 	 sdelay(30,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(5);
	 	 sdelay(100,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(5);
	 	 sdelay(50,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(7);
	 	 sdelay(50,ms);
	 } 
}
 
task tsk_9(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(4);
	 	 sdelay(20,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(1);
	 	 sdelay(100,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(5);
	 	 sdelay(1000,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(2);
	 	 sdelay(50,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(8);
	 	 sdelay(500,ms);
	 } 
}
 
task tsk_10(){
	 	 spriority(6);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(6);
	 	 sdelay(40,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(2);
	 	 sdelay(40,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(6);
	 	 sdelay(500,ms);
	 } 
}
 
task tsk_11(){
	 	 spriority(9);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(4);
	 	 sdelay(10,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(5);
	 	 sdelay(100,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(9);
	 	 sdelay(50,ms);
	 } 
}
 
task tsk_12(){
	 	 spriority(3);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(6);
	 	 sdelay(200,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(9);
	 	 sdelay(40,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(9);
	 	 sdelay(10,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(3);
	 	 sdelay(10,ms);
	 } 
}
 
task tsk_13(){
	 	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(9);
	 	 sdelay(100,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(4);
	 	 sdelay(10,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(4);
	 	 sdelay(100,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(4);
	 	 sdelay(100,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(4);
	 	 sdelay(100,ms);
	 } 
}
 
task tsk_14(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(8);
	 	 sdelay(20,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(8);
	 	 sdelay(20,ms);
	 } 
}
 
task tsk_15(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_400.dat");
	 	 spriority(3);
	 	 sdelay(30,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(1);
	 	 sdelay(200,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(4);
	 	 sdelay(1000,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(3);
	 	 sdelay(100,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(7);
	 	 sdelay(200,ms);
	 } 
}
 
task tsk_16(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(7);
	 	 sdelay(30,ms);
	 } 
}
 
task tsk_17(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(1);
	 	 sdelay(30,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(1);
	 	 sdelay(1000,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(8);
	 	 sdelay(1000,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(7);
	 	 sdelay(20,ms);
	 } 
}
 
task tsk_18(){
	 	 spriority(3);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(6);
	 	 sdelay(200,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(3);
	 	 sdelay(40,ms);
	 } 
}
 
task tsk_19(){
	 	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(3);
	 	 sdelay(100,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(8);
	 	 sdelay(200,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(4);
	 	 sdelay(20,ms);
	 } 
}
 
task tsk_20(){
	 	 spriority(9);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(1);
	 	 sdelay(10,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(6);
	 	 sdelay(1000,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(9);
	 	 sdelay(40,ms);
	 } 
}
 
task tsk_21(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(6);
	 	 sdelay(20,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(6);
	 	 sdelay(40,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(6);
	 	 sdelay(40,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(1);
	 	 sdelay(40,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(8);
	 	 sdelay(1000,ms);
	 } 
}
 
task tsk_22(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_500.dat");
	 	 spriority(3);
	 	 sdelay(30,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(5);
	 	 sdelay(200,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(8);
	 	 sdelay(50,ms);
	 	 qsort_small("input_300.dat");
	 	 spriority(6);
	 	 sdelay(20,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(7);
	 	 sdelay(40,ms);
	 } 
}
 
task tsk_23(){
	 	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(1);
	 	 sdelay(100,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(5);
	 	 sdelay(1000,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(6);
	 	 sdelay(50,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(3);
	 	 sdelay(40,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(4);
	 	 sdelay(200,ms);
	 } 
}
 
task tsk_24(){
	 	 spriority(9);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(9);
	 	 sdelay(10,ms);
	 } 
}
 
task tsk_25(){
	 	 spriority(6);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_100.dat");
	 	 spriority(3);
	 	 sdelay(40,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(6);
	 	 sdelay(200,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(6);
	 	 sdelay(40,ms);
	 } 
}
 
task tsk_26(){
	 	 spriority(5);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_300.dat");
	 	 spriority(2);
	 	 sdelay(50,ms);
	 	 qsort_small("input_400.dat");
	 	 spriority(5);
	 	 sdelay(500,ms);
	 } 
}
 
task tsk_27(){
	 	 spriority(1);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(9);
	 	 sdelay(1000,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(3);
	 	 sdelay(10,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(1);
	 	 sdelay(200,ms);
	 } 
}
 
task tsk_28(){
	 	 spriority(1);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_200.dat");
	 	 spriority(6);
	 	 sdelay(1000,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(1);
	 	 sdelay(40,ms);
	 	 qsort_small("input_200.dat");
	 	 spriority(1);
	 	 sdelay(1000,ms);
	 } 
}
 
task tsk_29(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 qsort_small("input_400.dat");
	 	 spriority(4);
	 	 sdelay(30,ms);
	 	 qsort_small("input_100.dat");
	 	 spriority(3);
	 	 sdelay(100,ms);
	 	 qsort_small("input_500.dat");
	 	 spriority(7);
	 	 sdelay(200,ms);
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
	 tsk_20();
	 tsk_21();
	 tsk_22();
	 tsk_23();
	 tsk_24();
	 tsk_25();
	 tsk_26();
	 tsk_27();
	 tsk_28();
	 tsk_29();
}