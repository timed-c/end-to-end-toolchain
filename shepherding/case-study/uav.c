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

void func_2(){
 	 struct sched_param param;
 	 int s, i;
 	 param.sched_priority = sched_get_priority_max(SCHED_FIFO);
 	 s=pthread_setschedparam(pthread_self(), SCHED_FIFO, &param);
 	 if(s != 0) printf("pthread_setschedparam");
 	 qsort_small("input_100.dat");
     //for(i=0; i<10000;i++){}
}

void func_3(){
    int i;
    for(i=0; i<1000000000; i++){}

}

task lidar_sensor(){
    int a=1;
	spolicy(FIFO_RM);
	spriority(4);
	stp(0, infty, ms);
	while(1){
        func_1(50);
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
        func_3();
        cread(chan1, b);
        cwrite(chan2, c);
	 	fdelay(250,ms);
	 }
}

task gps_signal(){
     int d=1;
	 spolicy(FIFO_RM);
	 spriority(4);
	 stp(0, infty, ms);
	 while(1){
        func_1(500);
        cwrite(chan3,d);
	 	sdelay(250,ms);
	 }
}


task control(){
  int e, f, g=1;
  spolicy(FIFO_RM);
  spriority(4);
  stp(0, infty, ms);
  while(1){
    cread(chan2, e);
    stp(10,50,ms);
    func_1(20);
    cread(chan3, f);
    func_1(30);
    stp(10,50,ms);
    func_1(10);
    cwrite(chan4,g);
    stp(30,50,ms);

  }
}

task stabilization(){
     int h, i;
	 spolicy(FIFO_RM);
	 spriority(2);
	 stp(0, infty, ms);
	 while(1){
        func_2();
        cread(chan4, h);
        cwrite(chan5, h);
        cread(chan6, i);
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
        func_1(50);
        cread(chan8,j);
	 	sdelay(10,ms);
	 }
}
task recieve_radio(){
     int k=1;
	 spolicy(FIFO_RM);
	 spriority(1);
	 stp(0, infty, ms);
	 while(1){
        func_2();
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
        func_2();
        cread(chan7,l);
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
        func_1(10);
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
        func_2();
        cread(chan5, n);
        cread(chan9, o);
	 	sdelay(50,ms);
	 }
}



 int main(int argc, char* argv[]){
	 gps_signal();
	 control();
	 stabilization();
	 reporting();
	 recieve_radio();
	 manage_radio();
	 fail_safe_handling();
	 transmit_servos();
     particle_filter();
     lidar_sensor();
}

