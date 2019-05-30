 #include <stdio.h> 
 #include <math.h> 
 #include <stdlib.h> 
 #include "cilktc.h" 
 #include "mbench.h" 

 
 FILE dfile;
void func(int x){
 	 int i; 
 	 for(i=0; i<x; i++){
 	 	 basicmath_small();}
}
 
task tsk_0(){
	 	 spriority(9);
	 stp(0, infty, ms);
	 while(1){
	 	 func(2);
	 	 spriority(7);
	 	 sdelay(10,ms);
	 	 func(1);
	 	 spriority(9);
	 	 sdelay(30,ms);
	 } 
}
 
task tsk_1(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 func(5);
	 	 spriority(6);
	 	 sdelay(20,ms);
	 	 func(1);
	 	 spriority(8);
	 	 sdelay(40,ms);
	 } 
}
 
task tsk_2(){
	 	 spriority(7);
	 stp(0, infty, ms);
	 while(1){
	 	 func(3);
	 	 spriority(7);
	 	 sdelay(30,ms);
	 } 
}
 
task tsk_3(){
	 	 spriority(9);
	 stp(0, infty, ms);
	 while(1){
	 	 func(1);
	 	 spriority(7);
	 	 sdelay(10,ms);
	 	 func(2);
	 	 spriority(9);
	 	 sdelay(30,ms);
	 } 
}
 
task tsk_4(){
	 	 spriority(8);
	 stp(0, infty, ms);
	 while(1){
	 	 func(3);
	 	 spriority(8);
	 	 sdelay(20,ms);
	 	 func(1);
	 	 spriority(8);
	 	 sdelay(20,ms);
	 } 
}
 
task tsk_5(){
	 	 spriority(5);
	 stp(0, infty, ms);
	 while(1){
	 	 func(4);
	 	 spriority(5);
	 	 sdelay(50,ms);
	 } 
}
 
task tsk_6(){
	 	 spriority(6);
	 stp(0, infty, ms);
	 while(1){
	 	 func(1);
	 	 spriority(9);
	 	 sdelay(40,ms);
	 	 func(1);
	 	 spriority(6);
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
}