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
 	 param.sched_priority = sched_get_priority_max(SCHED_FIFO);
 	 s=pthread_setschedparam(pthread_self(), SCHED_FIFO, &param);
 	 if(s != 0) printf("pthread_setschedparam");
 	 mbitcount(x);
    //for(i=0; i<1000; i++){}
}

task lidar_sensor(){
    int a=1;
	spolicy(FIFO_RM);
	spriority(4);
	stp(0, infty, ms);
	while(1){
        func_1(25);
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
        func_1(300);
	 	ftp(250,100,ms);
	 }
}

task gps_signal(){
     int d=1;
	 spolicy(FIFO_RM);
	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
        func_1(25);
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
    stp(10,250,ms);
    func_1(10);
    cread(chan3, f);
    func_1(15);
    stp(10,250,ms);
    func_1(5);
    cwrite(chan4,g);
    stp(230,250,ms);

  }
}

task stabilization(){
     int h, i;
	 spolicy(FIFO_RM);
	 spriority(2);
	 stp(0, infty, ms);
	 while(1){
        cread(chan4, h);
        func_1(5);
        cwrite(chan5, h);
        cread(chan6, i);
        func_1(5);
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
        func_1(100);
	 	sdelay(100,ms);
	 }
}
task recieve_radio(){
     int k=1;
	 spolicy(FIFO_RM);
	 spriority(1);
	 stp(0, infty, ms);
	 while(1){
        func_1(5);
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
        func_1(10);
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
        func_1(5);
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
        func_1(15);
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

