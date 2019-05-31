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
#define MBENCH 3

int period_table[]={1, 2, 5, 10, 20, 50, 100, 200, 1000};
int share_table[]={3, 2,  2,  25, 25, 3,  20, 1,  4};
int offset_list[]= {0};
//char* mibench_small[] = {"qsort_small(\"input_100.dat\")", "qsort_small(\"input_200.dat\")", "qsort_small(\"input_300.dat\")", "qsort_small(\"input_400.dat\")", "qsort_small(\"input_500.dat\")"};

 /*"qsort_small(\"input_small.dat\")", "fft(4, 4096)", "inverse_fft(4, 8192)", "crc(\"small.pcm\")"*/
char* mibench_large[] = {"basicmath_small()", "mbitcount(75000)", /*"qsort_small(\"input_small.dat\")", "fft(4, 4096)", "inverse_fft(4, 8192)", "crc(\"small.pcm\")"*/};

//char* mibench_large[] = {"basicmath_large()", "mbitcount(1125000)", "qsort_large(\"input_large.dat\")", /*"fft(8, 32768)", "inverse_fft(8, 32768)",*/ "crc(\"large.pcm\")"};


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
    int i, k;
    fprintf(fp, "\t \t spriority(%d);\n", priod);
}

void write_tail(FILE* fp){
    fprintf(fp, "\t } \n}");
}

void write_file_header(FILE* fp, char* bmark){
    fprintf(fp, " #include <stdio.h> \n #include <math.h> \n #include <stdlib.h> \n #include \"cilktc.h\" \n #include \"mbench.h\" \n");
    fprintf(fp, "\n \n FILE dfile;\n");
    if(!strcmp(bmark,"small")){
        fprintf(fp, "void func(int x){\n \t int i; \n \t for(i=0; i<x; i++){\n \t \t mbitcount(50);}\n}");
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
    if(knd == 0){
        fprintf(fp, "\t \t func(%d);\n", randnum);
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
    char* bmark;
    long randnum;
    int count = 0;
    float wcet;
    int mul;
    if(argc < 8){
        printf("Error: input parameters missing \nExpected input parameters are number-of-task, no-of-frames, range-of-offset, (small, large, mix), fname, kind, and wcet\n");
        return;
    }
    task = atoi(argv[1]);
    frame = atoi(argv[2]);
    offset = atoi(argv[3]);
    bmark = argv[4];
    sfdelay = atoi(argv[6]);
    wcet = atof(argv[7]);
    srand(time(0));
    int sum_frame = 0;
    float sum_wcet = 0;
    float util_array[100];
    int period_array[100];
    //tsk = (rand() % task) + 1;
    tsk = task;
    fp = fopen(argv[5], "w");
    write_file_header(fp, bmark);
    //printf("Number of tasks: %d \n", tsk);
    for(i=0; i<tsk; i++){
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
        if(offset != 0){
            ofst = rand() % offset;
        }
        else{
            ofst = 0;
        }
        write_spolicy(fp, frame_period);
        write_offset(fp, ofst);
        sum_wcet = 0;
        for(j=0; j<frme; j++){
            this_period = frame_period;
           // printf("%d %d\n", this_period, frame_period);
            knd = rand() % sfdelay;
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
            mul = write_workload(fp, (randnum+1), bmark, knd);
            if(j != (frme-1)){
                write_spolicy(fp, frame_period);
            }
            else{
                write_spolicy(fp, first_period);
            }
            write_frame(fp, knd, this_period);
            sum_wcet = sum_wcet + (mul*wcet);
        }
        write_tail(fp);
        period_array[i] = priod;
        util_array[i] = sum_wcet/priod;
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
    fclose(fp);
}
