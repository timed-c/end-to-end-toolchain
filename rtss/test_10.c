 #include <stdio.h> 
 #include <math.h> 
 #include <stdlib.h> 
 #include "cilktc.h" 
 #include "mbench.h" 

 
 FILE dfile;
void func(int x){
 	 int i; 
 	 for(i=0; i<x; i++){
 	 	 mbitcount(100);}
}
 
task tsk_0(){
	 	 spriority(1000);
	 stp(0, infty, ms);
	 while(1){
	 	 func(1);
	 	 spriority(1000);
	 	 sdelay(1000,ms);

 
task tsk_1(){
	 	 spriority(20);
	 stp(0, infty, ms);
	 while(1){
	 	 critical{ 
 	 	 func(2);}
	 	 spriority(20);
	 	 fdelay(20,ms);

 int main(int argc, char* argv[]){
	 tsk_0();
	 tsk_1();
}