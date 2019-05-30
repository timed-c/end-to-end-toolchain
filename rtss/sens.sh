#!/bin/bash
start=`date +%s`
../ktc/bin/ktc --enable-ext5 $1 -I. -L. -w
sudo cp job.csv input
sudo cp action.csv orginal_action
sudo perf stat ../sensitivity-analysis/bin/sensitivity $2 $3
end=`date +%s`

runtime=$((end-start))
echo "Runtime was $runtime"
