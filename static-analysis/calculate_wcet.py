import re
import subprocess
import os
import sys

def read_file(): 
    file = open("ktc_wcet_file_1.txt","r") 
    return file.readlines()
    file.close()

def write_file(tskname, wcet): 
    wfile.write(str(i)+":"+str(wcet)+"\n")
    wfile.close

flst = read_file() 
print(flst)
for i in range(len(flst)):
    funcname = ((flst[i].split(":"))[-1]).rstrip()
    tp = ((flst[i].split(":"))[1])
    tsk = ((flst[i].split(":"))[0])
    filename = sys.argv[2]
    print(funcname)
    if sys.argv[1] == "KTA":
        exe=". /opt/mcb32tools/environment && export KTA_WCET_RUNTIME_PATH=/vagrant/kta/runtime && /vagrant/kta/bin/kta wcet "+ filename + " " + funcname+ " -compile"
        #print(exe)
        op= subprocess.Popen(exe, shell=True, stdout=subprocess.PIPE).stdout.read()
        oplist=op.decode('utf8').split(" ")
        print(op)
        wfile=open(tsk+".wcet", "w")
        print(tp+":"+oplist[3])
        wfile.write(tp+":"+oplist[3])
        wfile.close()
    if sys.argv[1] == "OTAWA":
        finame="wcet_main.c"
        fnfp=open(finame, "w")
        fnfp.write("#include<stdio.h>\n"+"#include\""+filename+"\""+"\nvoid main(){")
        fnfp.write("\n")
        funccall=funcname+"();"
        fnfp.write(funccall)
        fnfp.write("\n}")
        fnfp.close()
        exe="/vagrant/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc --specs=nosys.specs wcet_main.c -o wcet_main" 
        op= subprocess.Popen(exe, shell=True, stdout=subprocess.PIPE).stdout.read()
        #exe="/vagrant/otawa/bin/mkff wcet_main > wcet_main.ff"
        exe="/vagrant/otawa/bin/mkff wcet_main > wcet_main.ff"
        op= subprocess.Popen(exe, shell=True, stdout=subprocess.PIPE).stdout.read()
        print(exe)
        exe = "sed -i 's/?/10/g' wcet_main.ff"
        op= subprocess.Popen(exe, shell=True, stdout=subprocess.PIPE).stdout.read()
        #input("Please modify the flow file and PRESS ENTER TO CONTINUE")
        #op= subprocess.Popen(exe, shell=True, stdout=subprocess.PIPE).stdout.read()
        exe="/vagrant/otawa/bin/owcet -s generic wcet_main"
        print(exe)
        op= subprocess.Popen(exe, shell=True, stdout=subprocess.PIPE).stdout.read()
        print(op)
        oplist=op.decode('utf8').split(" ")
        print(oplist[-2])
        wfile=open(tsk+".wcet", "w")
        print(tp+":"+oplist[-2])
        wfile.write(tp+":"+oplist[-2])
        wfile.close()

