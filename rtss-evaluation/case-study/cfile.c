 #include <stdio.h>
 #include <math.h>
 #include <stdlib.h>
 #include "cilktc.h"

FILE dfile;


task lidar_sensor(){
    int a=1;
    stp(0, infty, ms);
	while(1){
        mbitcount(8);
        sdelay(250, 50, ms);
	 }
}



task gps_signal(){
     int d=1;
     stp(0, infty, ms);
	 while(1){
        mbitcount(8);
	 	sdelay(250,ms);
	 }
}


task stabilization(){
     int h, i;
     stp(0, infty, ms);
	 while(1){
        mbitcount(3);
        sdelay(50,ms);
	 }
}

task reporting(){
     int j;
     stp(0, infty, ms);
	 while(1){
        mbitcount(20);
	 	sdelay(100,ms);
	 }
}
task recieve_radio(){
     int k=1;
     stp(0, infty, ms);
	 while(1){
        mbitcount(3);
	 	sdelay(25,ms);
	 }
}
task manage_radio(){
     int l;
     stp(0, infty, ms);
	 while(1){
        mbitcount(5);
	 	sdelay(25,ms);
	 }
}

task fail_safe_handling(){
     stp(0, infty, ms);
	 while(1){
        mbitcount(8);
	 	sdelay(50,ms);
	 }
}


task controller(){
  int e, f, g=1;
  stp(0, infty, ms);
  while(1){
    stp(10, 250, ms);
    mbitcount(5);
    stp(10, 250,ms);
    mbitcount(2);
    stp(230,250, ms);

  }
}

task transmit_servos(){
     stp(0, infty, ms);
	 while(1){
        mbitcount(6);
	 	sdelay(50,ms);
	 }
}


task particle_filter(){
     int b;
     int c=1;
	 stp(0, infty, ms);
	 while(1){
        mbitcount(30);
	 	stp(250,100,ms);
	 }
}


int main(int argc, char* argv[]){
     int z=1;
	 gps_signal();
	 controller();
	 stabilization();
	 reporting();
	 recieve_radio();
	 manage_radio();
	 fail_safe_handling();
	 transmit_servos();
     particle_filter();
     lidar_sensor();
}



