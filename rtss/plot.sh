#!/bin/bash
tsk=$1
exp=$2
var="tsk"
cd $exp
echo "x y ey" > plot.data
for ((i=1; i<=$tsk; i=i+1))
    do
        file="${var}_${i}.perf"
        tail -2 $file > log
        xvar=$i
        yvar=$(awk '{print $1}' log)
        pervar=$(awk '{print $7}' log)
        evar=${pervar::-1}
        hund=100
        eyvar=$(bc -l <<< "($evar / $hund)")
        echo "$xvar $yvar $eyvar" >> plot.data
    done
cp ../plot.tex .
pdflatex plot.tex
