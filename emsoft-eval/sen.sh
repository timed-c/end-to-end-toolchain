#!/bin/bash
name=$1
k=$2
j=$3
i=$4
echo "Generating Input to Schedulability Test"
../ktc/bin/ktc --enable-ext5 --save-temps $name -L. -llogs -lmbench -w -g
#echo "Schedulability Test"
#../timed-c-e2e-sched-analysis/build/nptest -r -c job.csv -a action.csv > output
#cp job.rta.csv output.rta
cp job.csv input
echo "Sensitivity Analysis"
../sensitivity-analysis/bin/sensitivity $k $j $i | tee $1.output
#rm *.csv
#rm *.rta
rm output
#rm input
rm *.out
rm *.cil.*
rm *.dot
rm *.o
rm *.i
rm *.json
rm trace
echo "Completed"
