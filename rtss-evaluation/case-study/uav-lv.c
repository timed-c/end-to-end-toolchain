 #include <stdio.h>
 #include <math.h>
 #include <stdlib.h>
 #include "cilktc.h"

FILE dfile;

int lvchannel(chan1);
int lvchannel(chan2);
int lvchannel(chan3);
int lvchannel(chan4);
int lvchannel(chan5);
int lvchannel(chan6);
int lvchannel(chan7);
int lvchannel(chan8);
int lvchannel(chan9);


void func_1(int x){
 	 struct sched_param param;
 	 int s, i;
 	 mbitcount(x);
    //for(i=0; i<1000; i++){}
}

task lidar_sensor(){
    int a=1;
	spolicy(FIFO_RM);
	spriority(4);
	stp(0, infty, ms);
	while(1){
        mbitcount(250);
        cwrite(chan1,a);
        sdelay(250, 50, ms);
	 }
}


task particle_filter(){
     int b;
     int c=1;
	 spolicy(FIFO_RM);
	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
        cread(chan1, b);
        cwrite(chan2, c);
        mbitcount(3000);
	 	ftp(250,100,ms);
	 }
}

task gps_signal(){
     int d=1;
	 spolicy(FIFO_RM);
	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
        mbitcount(250);
        cwrite(chan3,d);
	 	sdelay(250,ms);
	 }
}


task controller(){
  int e, f, g=1;
  spolicy(FIFO_RM);
  spriority(4);
  stp(0, infty, ms);
  while(1){
    cread(chan2, e);
    stp(0, 250, ms);
    mbitcount(100);
    cread(chan3, f);
    mbitcount(150);
    stp(0, 250,ms);
    mbitcount(50);
    cwrite(chan4,g);
    sdelay(250, ms);

  }
}

task stabilization(){
     int h, i;
	 spolicy(FIFO_RM);
	 spriority(2);
	 stp(0, infty, ms);
	 while(1){
        cread(chan4, h);
        mbitcount(50);
        cwrite(chan5, h);
        cread(chan6, i);
        mbitcount(50);
        cwrite(chan8, i);
	 	sdelay(50,ms);
	 }
}

task reporting(){
     int j;
	 spolicy(FIFO_RM);
	 spriority(2);
	 stp(0, infty, ms);
	 while(1){
        cread(chan8,j);
        mbitcount(1000);
	 	sdelay(100,ms);
	 }
}
task recieve_radio(){
     int k=1;
	 spolicy(FIFO_RM);
	 spriority(1);
	 stp(0, infty, ms);
	 while(1){
        mbitcount(50);
        cwrite(chan7,k);
	 	sdelay(25,ms);
	 }
}
task manage_radio(){
     int l;
	 spolicy(FIFO_RM);
	 spriority(1);
	 stp(0, infty, ms);
	 while(1){
        cread(chan7,l);
        mbitcount(100);
        cwrite(chan6,l);
	 	sdelay(25,ms);
	 }
}

task fail_safe_handling(){
     int m =1;
	 spolicy(FIFO_RM);
	 spriority(2);
	 stp(0, infty, ms);
	 while(1){
        mbitcount(250);
        cwrite(chan9,m);
	 	sdelay(50,ms);
	 }
}

task transmit_servos(){
     int n, o;
	 spolicy(FIFO_RM);
	 spriority(2);
	 stp(0, infty, ms);
	 while(1){
        cread(chan5, n);
        cread(chan9, o);
        mbitcount(150);
	 	sdelay(50,ms);
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

