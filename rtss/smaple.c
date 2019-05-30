#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int period[]={1, 2, 5, 10, 20, 50, 100, 200, 1000};
int share[]={3, 2,  2,  25, 25, 3,  20, 1,  4};

int sample_table(){
    int sample,weight, i;
    sample = rand()%85;
    i = 0;
    weight = 0;
    printf("%d", sample);
    while(i<9){
        weight = weight + share[i];
        if(sample < weight){
            return period[i];
        }
        i++;
    }
}

int sample_period(){
        int sample;
        sample = rand()%85;
        int x = 3;
        if(sample < x){
            return 1;
        }
        x = x + 2;
        if(sample < x ){
            return 2;
        }
        x = x + 2;
        if(sample < x){
            return 5;
        }
        x = x + 25;
        if(sample < x){
            return 10;
        }
        x = x + 25;
        if(sample < x){
            return 20;
        }
        x = x + 3;
        if(sample < x){
            return 50;
        }
        x = x + 1;
        if(sample < x){
            return 200;
        }
        x = x + 4;
        if(sample < x){
            return 1000;
        }
}

void main(int argc, char *argv[]){
    if(argc < 2){
        printf("task\n");
        return;
    }
    int task, i, sample, random;
    task = atoi(argv[1]);
    srand(time(0));
    i=0;
    sample=0;
    int p;
    while(i < task){
        i++;
        p = sample_table();
        printf("%d\n", p);
    }
}
