#!/bin/bash
name=$1
echo "Instrumentation"
../ktc/bin/ktc --enable-ext2 --save-temps $name -L. -llogs -lmbench  -w --link -g
echo "Generating Trace"
./a.out > trace
echo "Generating Input to Schedulability Test"
../ktc/bin/ktc --enable-ext3 --save-temps $name -L. -llogs -lmbench -w --link -g
echo 'Schedulability Test \n'
../timed-c-e2e-sched-analysis/build/nptest -r job.csv > output
cp job.rta.csv output.rta
cp job.csv input
echo "Sensitivity Analysis"
../sensitivity-analysis/bin/sensitivity
rm *.csv
rm *.rta
rm output
rm input
rm *.out
rm *.cil.*
rm *.dot
rm *.o
rm *.i
rm *.json
rm tsk_*
rm check
rm trace
echo "Completed"
