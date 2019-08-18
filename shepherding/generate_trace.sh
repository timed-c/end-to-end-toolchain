#!/bin/bash
tsk=$1
frame=$2
offset=$3
size=$4
k=$5
epsilon=$6
iter=$7
kind=$8
util=$9
var="tsk"
#echo "Task = ${tsk}, Frame =${frame}, Offset=${offset}, Size=${size}, k=${k}, Epsilon=${epsilon}, Iter=${iter}, Kind=${kind}, Seed=${seed}" > config
for ((j=10; j<=$tsk;j=j+1))
    do
        exp="${j}_${var}_util9"
        mkdir $exp
        cd $exp
        log="s_${j}_log"
        rm -f traces
        mkdir traces
        ssh saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding && mkdir $exp"
        for ((i=1; i<=1; i=i+1))
        do
            fileg="${var}_${j}_${i}"
            ../generate-shepherd $j $frame $offset $size $fileg $kind 600 | tee -a $log
            for ((z=0; z<2;z++))
                do
                    if [[ "$z" == '0' ]]; then
                        file="${fileg}_edf.c"
                        exe="${var}_${j}_${i}"
                        cilfile="${var}_${j}_${i}_edf.cil.c"
                        dir="${var}_${j}_${i}_traces_edf"
                        sim_out="sim_${var}_${j}_${i}_edf.perf"
                        util_9="util_9_${var}_${j}_${i}_edf.perf"
                        util_1="util_1_${var}_${j}_${i}_edf.perf"
                    fi
                      if [[ "$z" == '1' ]]; then
                        file="${fileg}_fp.c"
                        exe="${var}_${j}_${i}"
                        cilfile="${var}_${j}_${i}_fp.cil.c"
                        dir="${var}_${j}_${i}_traces_fp"
                        sim_out="sim_${var}_${j}_${i}_fp.perf"
                        util_9="util_9_${var}_${j}_${i}_fp.perf"
                        util_1="util_1_${var}_${j}_${i}_fp.perf"
                    fi
                    sudo ../../bin/ktc $file --posix --timing-param $k $iter
                    arm-linux-gnueabihf-gcc  $cilfile -I../ -L../ -lraspmplogs -lraspcrc -lraspbitcount -lraspbasicmath -lraspqsort -lpthread -lktcrasp -lm -lrt -w -o $exe
                    mkdir $dir
                    rm -f *.ktc.trace
                    scp $exe pi@10.42.0.101:/home/pi/Documents/rtss
                    ssh pi@10.42.0.101 "cd && cd /home/pi/Documents/rtss/ && ./clean.sh && sudo ./$exe $k $iter && scp *.ktc.trace saranya@10.42.0.1:/home/saranya/Dokument/e2e/shepherding/$exp && ./clean.sh && exit"
                    cp *.ktc.trace $dir
                    cp $dir/*.ktc.trace traces
                    cp $file $dir/
                    scp -r traces saranya@130.237.20.223:/home/saranya/Documents/end-to-end-toolchain/shepherding/$exp
                    scp -r $file saranya@130.237.20.223:/home/saranya/Documents/end-to-end-toolchain/shepherding/$exp
                    #echo "sim"
                    #ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && perf stat -o $sim_out ../../bin/sens $file --param $k $epsilon $util --sim | tee -a $log && tail -2 $sim_out > immlog"
                    #ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && cat immlog >> $log && echo ######## | tee -a $log && rm immlog"
                    ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && perf stat -o $util_9 ../../bin/sens $file --param $k $epsilon 0.9 --util $z | tee -a $log && tail -2 $util_9 > immlog"
                    ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && cat immlog >> $log && echo ######## | tee -a $log && rm immlog"
                    #ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && perf stat -o $util_1 ../../bin/sens $file --param $k $epsilon 1.0 --util | tee -a $log && tail -2 $util_1 > immlog"
                    #ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && cat immlog >> $log && echo ######## | tee -a $log && rm immlog && rm $file && rm -r traces"
                    #mv input $dir
                    #mv output $dir
                    #mv *.csv $dir
                    rm -f *.ktc.trace
                    rm -f *.cil.c
                    rm -f traces/*.ktc.trace
                    #rm -f $exe
                    rm -f $file
                    echo "#######" | tee -a $log
                done
        done
            cd ..
    done

