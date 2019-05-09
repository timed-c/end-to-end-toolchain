#!/bin/bash
name=$1
echo "Instrumentation"
../ktc/bin/ktc --enable-ext2 --save-temps $name -L. -llogs -lmbench  -w --link -g
echo "Generating Trace"
./a.out > trace
echo "Generating Input to Schedulability Test"
../ktc/bin/ktc --enable-ext3 --save-temps $name -L. -llogs -lmbench -w --link -g
echo 'Schedulability Test'
../timed-c-e2e-sched-analysis/build/nptest -r -c job.csv > output
cp job.rta.csv output.rta
cp job.csv input
echo "Sensitivity Analysis"
../sensitivity-analysis/bin/sensitivity
echo "Completed"
