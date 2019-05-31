#!/bin/bash
tsk=$1
frame=$2
offset=$3
size=$4
k=$5
epsilon=$6
iter=$7
kind=$8
wcet=$9
to=$10
var="tsk"
echo "Task = ${tsk}, Frame =${frame}, Offset=${offset}, Size=${size}, k=${k}, Epsilon=${epsilon}, Iter=${iter}, Kind=${kind}, Seed=${seed}" > config
for ((j=3; j<=$tsk;j=j+2))
    do
        exp="${j}_${var}"
        mkdir $exp
        cd $exp
        log="${j}_log"
        mv config $exp
        echo "*******Taskset with ${j} tasks*********" | tee $log
        mkdir traces
        for ((i=1; i<=10; i=i+1))
        do
            file="${var}_${j}_${i}.c"
            ../generate $tsk $frame $offset $size $file $kind $wcet | tee -a $log
            exe="${var}_${j}_${i}"
            sudo ../../bin/ktc $file --posix --timing-param $k $iter
            cilfile="${var}_${j}_${i}.cil.c"
            arm-linux-gnueabihf-gcc  $cilfile -I../ -L../ -lraspmplogs -lraspcrc -lraspbitcount -lraspbasicmath -lraspqsort -lpthread -lktcrasp -lm -lrt -w -o $exe
            dir="${var}_${j}_${i}_traces"
            mkdir $dir
            rm -f *.ktc.trace
            scp $exe pi@10.42.0.101:/home/pi/Documents/rtss
            ssh pi@10.42.0.101 "cd && cd /home/pi/Documents/rtss/ && ./clean.sh && sudo ./$exe $k $iter && scp *.ktc.trace saranya@10.42.0.1:/home/saranya/Dokument/e2e/rtss/$exp && rm $exe && ./clean.sh && exit"
            cp *.ktc.trace $dir
            cp *.ktc.trace traces
            cp $file $dir
            pout="${var}_${j}_${i}.perf"
            date
            sudo perf stat -o $pout ../../bin/sens $file --param $k $epsilon $to | tee -a $log
            tail -2 $pout > imm_log
            yvar=$(awk '{print $1}' imm_log)
            echo "Time Elapsed:${yvar}" | tee -a $log
            rm imm_log
            mv input $dir
            mv output $dir
            rm -f *.ktc.trace
            rm -f *.cil.c
            rm traces/*.ktc.trace
            rm $exe
            rm -f $file
            echo "#######" | tee -a $log
        done
            cd ..
    done

