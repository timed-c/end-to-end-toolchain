#!/bin/bash
tsk=$1
frame=$2
offset=$3
size=$4
k=$5
epsilon=$6
iter=$7
kind=$8
exp=$9
var="tsk"
RANDOM=`date +%s`
seed=$RANDOM
mkdir $exp
cd $exp
mkdir traces
echo "Task = ${tsk}, Frame =${frame}, Offset=${offset}, Size=${size}, k=${k}, Epsilon=${epsilon}, Iter=${iter}, Kind=${kind}, Seed=${seed}" > config
for ((i=1; i<=$tsk; i=i+1))
    do
        file="${var}_${i}.c"
        ../generate $i $frame $offset $size $file $seed $kind
        exe="${var}_${i}"
        sudo ../../bin/ktc $file --posix --timing-param $k $iter
        cilfile="${var}_${i}.cil.c"
        arm-linux-gnueabihf-gcc  $cilfile -I../ -L../ -lraspmplogs -lraspcrc -lraspbitcount -lraspbasicmath -lraspqsort -lpthread -lktcrasp -lm -lrt -w -o $exe
        dir="${var}_${i}_traces"
        mkdir $dir
        rm -f *.ktc.trace
        scp $exe pi@10.42.0.101:/home/pi/Documents/rtss
        ssh pi@10.42.0.101 "cd && cd /home/pi/Documents/rtss/ && ./clean.sh && sudo ./$exe $k $iter && scp *.ktc.trace saranya@10.42.0.1:/home/saranya/Dokument/e2e/rtss/$exp && rm $exe && ./clean.sh && exit"
        cp *.ktc.trace $dir
        while [ $? != 0 ];
        do
            $iter=$iter - 10
            echo "$iter"
            ssh pi@10.42.0.101 "cd && cd /home/pi/Documents/rtss/ && ./clean.sh && sudo ./$exe $k $iter && scp *.ktc.trace saranya@10.42.0.1:/home/saranya/Dokument/e2e/rtss/$exp && rm $exe && ./clean.sh && exit"
            cp *.ktc.trace $dir
        done
        cp *.ktc.trace traces
        cp $file $dir
        pout="${var}_${i}.perf"
        date
        sudo perf stat -r 3 -o $pout ../../bin/sens $file --param $k $epsilon | tee vary_frame.txt
        mv input $dir
        mv sens-output.txt $dir
        mv output $dir
        mv vary_frame.txt $dir
        rm -f *.ktc.trace
        rm -f *.cil.c
        rm traces/*.ktc.trace
        rm -f $file
    done

