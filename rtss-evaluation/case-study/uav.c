 #include <stdio.h>
 #include <math.h>
 #include <stdlib.h>
 #include "cilktc.h"

FILE dfile;

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
        func_1(50);
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
        func_1(600);
	 	ftp(250,100,ms);
	 }
}

task gps_signal(){
     int d=1;
	 spolicy(FIFO_RM);
	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
        func_1(50);
	 	sdelay(250,ms);
	 }
}


task controller(){
  int e, f, g=1;
  spolicy(FIFO_RM);
  spriority(4);
  stp(0, infty, ms);
  while(1){
    stp(0,250,ms);
    func_1(20);
    func_1(30);
    stp(0,250,ms);
    func_1(10);
    stp(250,250,ms);

  }
}

task stabilization(){
     int h, i;
	 spolicy(FIFO_RM);
	 spriority(2);
	 stp(0, infty, ms);
	 while(1){
        func_1(10);
        func_1(10);
	 	sdelay(50,ms);
	 }
}

task reporting(){
     int j;
	 spolicy(FIFO_RM);
	 spriority(2);
	 stp(0, infty, ms);
	 while(1){
        func_1(200);
	 	sdelay(100,ms);
	 }
}
task recieve_radio(){
     int k=1;
	 spolicy(FIFO_RM);
	 spriority(1);
	 stp(0, infty, ms);
	 while(1){
        func_1(10);
	 	sdelay(25,ms);
	 }
}
task manage_radio(){
     int l;
	 spolicy(FIFO_RM);
	 spriority(1);
	 stp(0, infty, ms);
	 while(1){
        func_1(20);
	 	sdelay(25,ms);
	 }
}

task fail_safe_handling(){
     int m =1;
	 spolicy(FIFO_RM);
	 spriority(2);
	 stp(0, infty, ms);
	 while(1){
        func_1(10);
	 	sdelay(50,ms);
	 }
}

task transmit_servos(){
     int n, o;
	 spolicy(FIFO_RM);
	 spriority(2);
	 stp(0, infty, ms);
	 while(1){
        func_1(30);
	 	sdelay(50,ms);
	 }
}

int main_rt(int argc, char* argv[]){
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

