#include<stdio.h>
#include<cilktc.h>
#include "input.h"
#include "func.c"
#include "examples/nsichneu.c"

FILE dfile;

task tsk_foo(){
  stp(0, infty, ms);
  while(1){
    factcall(5);
    htp(10,10,ms);
  }
}

task tsk_bar(){
  stp(0, infty, ms);
  while(1){
    NSicherNeu();
    stp(10,10,ms);
  }
}

int main(int argc, char* argv[]){
  long unsigned int targ = 10;
  tsk_foo();
  tsk_bar();
}
