#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <sched.h>
#include <string.h>

#define KIND 1
#define TASK 100
#define PERIOD 9
#define FRAME 10
#define OFFSET 1
#define MBENCH 10

int period_table[]={1, 2, 5, 10, 20, 50, 100, 200, 1000};
int share_table[]={3, 2,  2,  25, 25, 3,  20, 1,  4};
int offset_list[]= {0};
//char* mibench_small[] = {"qsort_small(\"input_100.dat\")", "qsort_small(\"input_200.dat\")", "qsort_small(\"input_300.dat\")", "qsort_small(\"input_400.dat\")", "qsort_small(\"input_500.dat\")"};

 /*"qsort_small(\"input_small.dat\")", "fft(4, 4096)", "inverse_fft(4, 8192)", "crc(\"small.pcm\")"*/
char* mibench_large[] = {"basicmath_small()", "mbitcount(75000)", /*"qsort_small(\"input_small.dat\")", "fft(4, 4096)", "inverse_fft(4, 8192)", "crc(\"small.pcm\")"*/};

//char* mibench_large[] = {"basicmath_large()", "mbitcount(1125000)", "qsort_large(\"input_large.dat\")", /*"fft(8, 32768)", "inverse_fft(8, 32768)",*/ "crc(\"large.pcm\")"};


/*void change_to_max_priority(){
    struct sched_param param;
    int s;
    param.sched_priority = sched_get_priority_max(SCHED_FIFO);
    s = pthread_setschedparam(pthread_self(), SCHED_FIFO, &param);
    if (s != 0)
        printf("pthread_setschedparam");
}*/

void write_task_header(FILE* fp, int num){
    fprintf(fp,"\n \ntask tsk_%d(){\n", num);
}

void write_frame(FILE* fp, int knd, int priod){
    int i, k;
    if(knd == 0){
        fprintf(fp, "\t \t sdelay(%d,ms);\n", priod);
    }
    else{
        fprintf(fp, "\t \t fdelay(%d,ms);\n", priod);
    }
}

void write_spolicy(FILE* fp, int priod){
    int i, k, p;
    for(i = 0; i<9; i++){
        if(period_table[i] == priod){
            p = i+1;
            break;
        }
    }
    fprintf(fp, "\t \t spriority(%d);\n", p);
}

void write_sched(FILE* fp, int p){
    if (p == 1){
        fprintf(fp, "\t \t spolicy(EDF);\n");
    }
    else{
        fprintf(fp, "\t \t spolicy(FIFO_RM);\n");
    }

}


void write_tail(FILE* fp){
    fprintf(fp, "\t } \n}");
}

void write_file_header(FILE* fp, char* bmark){
    fprintf(fp, " #include <stdio.h> \n #include <math.h> \n #include <stdlib.h> \n #include \"cilktc.h\" \n #include \"mbench.h\" \n");
    fprintf(fp, "\n \n FILE dfile;\n");
    if(!strcmp(bmark,"small")){
        //fprintf(fp, "void func(int x){\n \t int i; \n \t for(i=0; i<1; i++){\n \t \t mbitcount(x);}\n}");
        fprintf(fp, "void func(int x){\n \t struct sched_param param; \n \t int s, i; \n \t param.sched_priority = sched_get_priority_max(SCHED_FIFO); \n \t s=pthread_setschedparam(pthread_self(), SCHED_FIFO, &param); \n \t if(s != 0) printf(\"pthread_setschedparam\");\n \t mbitcount(x); \n}");

    }
    if(!strcmp(bmark,"large")){
        fprintf(fp, "void func(int x){\n \t int i; \n \t for(i=0; i<x; i++){\n \t \t mbitcount(1000);}\n}");
    }
}

void write_main(FILE* fp, int num){
    int i;
    fprintf(fp, "\n int main(int argc, char* argv[]){\n");
    for(i=0; i<num; i++){
        fprintf(fp, "\t tsk_%d();\n", i);
    }
    fprintf(fp, "}");
}


void write_offset(FILE* fp, int ofst){
    if(ofst == 0){
        fprintf(fp, "\t stp(0, infty, ms);\n");
    }
    else{
        fprintf(fp, "\t stp(%d, infty, ms);\n", ofst);
    }
    fprintf(fp, "\t while(1){\n");

}


int write_workload(FILE* fp, int randnum, char* bmark, int knd){
    int ret;
    int arg = randnum * 10;
    if(knd == 0){
        fprintf(fp, "\t \t func(%d);\n", arg);
        ret = randnum;
    }
    else{
        if(randnum % 2 == 0){
            fprintf(fp, "\t \t critical{ \n \t \t func(1);}\n");
            ret = 1;
        }
        else{
            fprintf(fp, "\t \t critical{ \n \t \t func(1);}\n");
            ret = 2;
        }
        //fprintf(fp, "\t \t critical{ \n \t \t func(1);}\n");
    }
    return ret;
}

int sample_table(){
    int sample,weight, i;
    sample = rand()%85;
    i = 0;
    weight = 0;
    while(i<9){
        weight = weight + share_table[i];
        if(sample < weight){
            return period_table[i];
        }
        i++;
    }
}

void main(int argc, char *argv[]){
    int tsk, frme, priod, knd, ofst, next_priod, first_frame, frame_period, sum_period;
    int task, frame, offset, first_period;
    int i, j, seed, sfdelay, this_period;
    FILE* fp;
    FILE* fp1;
    char* bmark;
    long randnum;
    int count = 0;
    char fpname[50];
    int policy;
    int mul;
    if(argc < 8){
        printf("Error: input parameters missing \nExpected input parameters are number-of-task, no-of-frames, range-of-offset, (small, large, mix), fname, kind, and policy\n");
        return;
    }
    task = atoi(argv[1]);
    frame = atoi(argv[2]);
    offset = atoi(argv[3]);
    bmark = argv[4];
    sfdelay = atoi(argv[6]);
    policy = atoi(argv[7]);
    srand(time(0));
    int sum_frame = 0;
    float sum_wcet = 0;
    float util_array[100];
    int period_array[100];
    int restrict_fdelay = 0;
    //tsk = (rand() % task) + 1;
    tsk = task;
    fp = fopen(argv[5], "w");
    strcpy(fpname, argv[5]);
    strcat(fpname, "_fp");
    fp1 = fopen(fpname, "w");
    write_file_header(fp, bmark);
     write_file_header(fp1, bmark);
    //printf("Number of tasks: %d \n", tsk);
    for(i=0; i<tsk; i++){
        restrict_fdelay = 0;
        count =0;
        priod = sample_table();
        do{
            frme = ((rand()) % frame) + 1;
        }while(priod < frme);
        frame_period = priod/frme;
        first_period = frame_period;
        sum_period = frame_period;
        count++;
        //printf("Number of frames in task t_%d : %d\n", i, frme);
        write_task_header(fp, i);
        write_task_header(fp1, i);
        if(offset != 0){
            ofst = rand() % offset;
        }
        else{
            ofst = 0;
        }
        write_sched(fp, 1);
        write_sched(fp1, 2);
        write_spolicy(fp, priod);
        write_offset(fp, ofst);
        write_spolicy(fp1, priod);
        write_offset(fp1, ofst);
        for(j=0; j<frme; j++){
            this_period = frame_period;
           // printf("%d %d\n", this_period, frame_period);
            knd = rand() % sfdelay;
            if(restrict_fdelay == 1){
                knd = 0;
            }
            if(restrict_fdelay == 0 && knd == 1){
                restrict_fdelay == 1;
            }
            //printf("--- %d %d %d %d\n", priod, sum_period, frme, count);
            if(count < (frme -1) ){
                frame_period = ((priod) - sum_period)/((frme + 1) - count);
                sum_period = sum_period + frame_period;
                count++;
            }
            else{
                frame_period = (priod) - sum_period;
            }
            randnum = rand()% MBENCH;
            if(i <=  0){
                mul = write_workload(fp, (randnum+1), bmark, knd);
                mul = write_workload(fp1, (randnum+1), bmark, knd);
            }
            else{
                mul = write_workload(fp, randnum, bmark, knd);
                mul = write_workload(fp1, randnum, bmark, knd);
            }
            if(j != (frme-1)){
                write_spolicy(fp, priod);
                write_spolicy(fp1, priod);
            }
            else{
                write_spolicy(fp, priod);
                write_spolicy(fp1, priod);
            }
            write_frame(fp, knd, this_period);
            write_frame(fp1, knd, this_period);
        }
        write_tail(fp);
        write_tail(fp1);
        period_array[i] = priod;
    }
    int k;
    printf("Period:{");
    for(k=0; k<tsk; k++){
        printf("%d,", period_array[k]);
    }
    printf("}\n");
    /*printf("Utilization:{");
    float sum_util=0;
    for(k=0; k<tsk; k++){
        printf("%f,", util_array[k]);
        sum_util = sum_util + util_array[k];
    }
    printf("}\n");
    printf("Sum Utilization:%f\n", sum_util);*/
    //findlcm(lcm_arr, tsk);
    write_main(fp, tsk);
    write_main(fp1, tsk);
    fclose(fp);
    fclose(fp1);
}
