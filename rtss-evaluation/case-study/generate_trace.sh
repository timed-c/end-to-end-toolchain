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
limit=${10}
var="tsk"
#echo "Task = ${tsk}, Frame =${frame}, Offset=${offset}, Size=${size}, k=${k}, Epsilon=${epsilon}, Iter=${iter}, Kind=${kind}, Seed=${seed}" > config
for ((j=20; j<=$tsk;j=j+4))
    do
        exp="${j}_${var}_final"
        mkdir $exp
        cd $exp
        rm -f traces
        mkdir traces
        ssh saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding && mkdir $exp"
        counter=1
        for ((i=35; i<=50; i=i+$counter))
        do
            counter=1
            fileg="${var}_${j}_${i}"
           ../generate-shepherd $j $frame $offset $size $fileg $kind 600 | tee -a $log
            for ((z=1; z<2;z++))
                do
                    if [[ "$z" == '0' ]]; then
                        file="${fileg}_edf.c"
                        exe="${var}_${j}_${i}"
                        cilfile="${var}_${j}_${i}_edf.cil.c"
                        dir="${var}_${j}_${i}_traces_edf"
                        sim_out="sim_${var}_${j}_${i}_edf.perf"
                        util_9="util_9_${var}_${j}_${i}_edf.perf"
                        util_1="util_1_${var}_${j}_${i}_edf.perf"
                        log="EDF_${j}_log"

                    fi
                      if [[ "$z" == '1' ]]; then
                        file="${fileg}_fp.c"
                        exe="${var}_${j}_${i}"
                        cilfile="${var}_${j}_${i}_fp.cil.c"
                        dir="${var}_${j}_${i}_traces_fp"
                        sim_out="sim_${var}_${j}_${i}_fp.perf"
                        util_9="final_${var}_${j}_${i}_fp.perf"
                        util_1="final ${var}_${j}_${i}_fp.perf"
                        log="final_${j}_log"
                    fi
                    sudo ../../bin/ktc $file --posix --timing-param $k $iter
                    arm-linux-gnueabihf-gcc  $cilfile -I../ -L../ -lraspmplogs -lraspcrc -lraspbitcount -lraspbasicmath -lraspqsort -lpthread -lktcrasp -lm -lrt -w -o $exe
                    mkdir $dir
                    rm -f *.ktc.trace
                    scp $exe pi@10.42.0.101:/home/pi/Documents/rtss
                    ssh pi@10.42.0.101 "cd && cd /home/pi/Documents/rtss/ && ./clean.sh && sudo ./$exe $k $iter && scp *.ktc.trace saranya@10.42.0.1:/home/saranya/Dokument/e2e/shepherding/$exp && ./clean.sh && exit"
                    cp *.ktc.trace $dir
                    cp $dir/*.ktc.trace traces
                    if [ "$(find $dir -mindepth 1 -print -quit 2>/dev/null)" ]; then
                        cp $file $dir/
                        scp -r traces saranya@130.237.20.223:/home/saranya/Documents/end-to-end-toolchain/shepherding/$exp
                        scp -r $file saranya@130.237.20.223:/home/saranya/Documents/end-to-end-toolchain/shepherding/$exp
                        date
                        #ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && perf stat -o $sim_out ../../bin/sens $file --param $k $epsilon $util --sim | tee -a $log && tail -2 $sim_out > immlog"
                        #ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && cat immlog >> $log && echo ######## | tee -a $log && rm immlog"
                        ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && perf stat -o $util_9 ../../bin/sens $file --param $k $epsilon 0.98 --util $z $limit 1.0 | tee -a $log && tail -2 $util_9 > immlog"
                        ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && cat immlog >> $log && echo ######## | tee -a $log && rm immlog"
                        #ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && perf stat -o $util_9 ../../bin/sens $file --param $k $epsilon 0.98 --util $z | tee -a $log && tail -2 $util_9 > immlog"
                        #ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && cat immlog >> $log && echo ######## | tee -a $log && rm immlog"
                        #ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && perf stat -o $util_1 ../../bin/sens $file --param $k $epsilon 1.0 --util | tee -a $log && tail -2 $util_1 > immlog"
                        #ssh -tt saranya@130.237.20.223 "cd /home/saranya/Documents/end-to-end-toolchain/shepherding/$exp && cat immlog >> $log && echo ######## | tee -a $log && rm immlog && rm $file && rm -r traces"
                        #mv input $dir
                        #mv output $dir
                        #mv *.csv $dir
                        scp saranya@130.237.20.223:/home/saranya/Documents/end-to-end-toolchain/shepherding/$exp/$log .
                       # discard=$(tail -5 $log | head  -1)
                       # act=$(echo $discard)
                        # if [[ $discard = $act ]]; then
                          #  echo "discarding ...... "
                           # counter=0
                        #fi
                    else
                        counter=0
                    fi
                    rm -f *.ktc.trace
                    rm -f *.cil.c
                    rm -f traces/*.ktc.trace
                    #rm -f $exe
                    rm -f $file
                done
        done
            cd ..
    done

