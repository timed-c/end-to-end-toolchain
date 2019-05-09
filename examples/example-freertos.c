/*tasks with periodic loop*/

#include <freertos/FreeRTOS.h>
#include <freertos/semphr.h>
#include <freertos/task.h>
#include <freertos/queue.h>
#include <stdlib.h>
#include <cilktc-free.h>


task tsk_a(){
    printf("start of delay");
    sdelay(10, ms);
    printf("delayed for 10 ms");
}


void main(){
    tsk_a();
}
