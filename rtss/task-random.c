#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <sched.h>
#include <string.h>

#define KIND 1
#define TASK 100
#define PERIOD 5
#define FRAME 10
#define OFFSET 1
#define MBENCH 5

int period_list[] = {10, 20, 30, 40, 50};
int priority_list[] = {9, 8, 7, 6, 5, 4, 3, 2, 1};
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
        fprintf(fp, "\t \t sdelay(%d,ms);\n", period_list[priod]);
    }
    else{
        fprintf(fp, "\t \t fdelay(%d,ms);\n", period_list[priod]);
    }
}

void write_spolicy(FILE* fp, int priod){
    int i, k;
    fprintf(fp, "\t \t spriority(%d);\n", priority_list[priod]);
}

void write_tail(FILE* fp){
    fprintf(fp, "\t } \n}");
}

void write_file_header(FILE* fp, char* bmark){
    fprintf(fp, " #include <stdio.h> \n #include <math.h> \n #include <stdlib.h> \n #include \"cilktc.h\" \n #include \"mbench.h\" \n");
    fprintf(fp, "\n \n FILE dfile;\n");
    if(!strcmp(bmark,"small")){
        fprintf(fp, "void func(int x){\n \t int i; \n \t for(i=0; i<x; i++){\n \t \t basicmath_small();}\n}");
    }
    if(!strcmp(bmark,"large")){
        fprintf(fp, "void func(int x){\n \t int i; \n \t for(i=0; i<x; i++){\n \t \t basicmath_large();}\n}");
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


void write_workload(FILE* fp, int randnum, char* bmark){
     fprintf(fp, "\t \t func(%d);\n", randnum);
}

void main(int argc, char *argv[]){
    int tsk, frme, priod, knd, ofst, next_priod, first_frame;
    int task, frame, offset, stask, sframe;
    int i, j;
    int count1, count2;
    FILE* fp;
    char* bmark;
    long randnum;
    char filename[100];
    if(argc < 5){
        printf("Error: input parameters missing \nExpected input parameters are 1 to no-of-task, range of frames, range-of-offset, (small, large, mix)\n");
        return;
    }
    task = atoi(argv[1]);
    frame = atoi(argv[2]);
    offset = atoi(argv[3]);
    bmark = argv[4];
    srand(time(0));
    int lcm_arr[50];
    int sum_frame =0;
    //tsk = (rand() % task) + 1;
    tsk = task;
    for(count2=1; count2<=frame; count2++){
    for(count1=1; count1<=tsk; count1++){
        sprintf(filename, "tsk_%d_frame_%d.c", count1, count2);
        fp = fopen(filename, "w");
        write_file_header(fp, bmark);
        for(i=0; i<count1; i++){
            frme = count2;
            priod = rand() % PERIOD;
            first_frame = priod;
            write_task_header(fp, i);
            if(offset != 0){
                ofst = rand() % offset;
            }
            else{
                ofst = 0;
            }
            write_spolicy(fp, priod);
            write_offset(fp, ofst);
            for(j=0; j<frme; j++){
                knd = rand() % KIND;
                if(j != frme-1){
                    next_priod = rand() % PERIOD;
                }
                else{
                    next_priod = first_frame;
                }
                randnum = rand()% MBENCH;
                write_workload(fp, (randnum+1), bmark);
                write_spolicy(fp, next_priod);
                write_frame(fp, knd, priod);
                priod = next_priod;
                sum_frame = sum_frame + priod;
            }
            write_tail(fp);
        }
        write_main(fp, count1);
        fclose(fp);
    }
    }
}
