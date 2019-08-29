 #include <stdio.h>
 #include <math.h>
 #include <stdlib.h>
 #include "cilktc-free.h"

FILE dfile;


task lidar_sensor(){
    int a=1;
    stp(0, infty, ms);
	while(1){
        mbitcount(25);
        sdelay(250, 50, ms);
	 }
}



task gps_signal(){
     int d=1;
     stp(0, infty, ms);
	 while(1){
        mbitcount(25);
	 	sdelay(250,ms);
	 }
}


task stabilization(){
     int h, i;
     stp(0, infty, ms);
	 while(1){
        mbitcount(5);
        sdelay(50,ms);
	 }
}

task reporting(){
     int j;
     stp(0, infty, ms);
	 while(1){
        mbitcount(100);
	 	sdelay(100,ms);
	 }
}
task recieve_radio(){
     int k=1;
     stp(0, infty, ms);
	 while(1){
        mbitcount(5);
	 	sdelay(25,ms);
	 }
}
task manage_radio(){
     int l;
     stp(0, infty, ms);
	 while(1){
        mbitcount(10);
	 	sdelay(25,ms);
	 }
}

task fail_safe_handling(){
     stp(0, infty, ms);
	 while(1){
        mbitcount(25);
	 	sdelay(50,ms);
	 }
}

task transmit_servos(){
     stp(0, infty, ms);
	 while(1){
        mbitcount(15);
	 	sdelay(50,ms);
	 }
}

task controller(){
  int e, f, g=1;
  stp(0, infty, ms);
  while(1){
    stp(0, 250, ms);
    mbitcount(10);
    stp(0, 250,ms);
    mbitcount(5);
    sdelay(250, ms);

  }
}

task particle_filter(){
     int b;
     int c=1;
	 stp(0, infty, ms);
	 while(1){
        mbitcount(300);
	 	stp(250,100,ms);
	 }
}


 int main(int argc, char* argv[]){
     int z=1;
	 gps_signal();
	 stabilization();
	 reporting();
	 recieve_radio();
	 manage_radio();
	 fail_safe_handling();
     lidar_sensor();
}
