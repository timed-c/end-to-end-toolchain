import re
import subprocess
import os
import sys

def read_file(): 
    file = open("ktc_wcet_file.txt","r") 
    return file.readlines()
    file.close()

def write_file(tskname, wcet): 
    wfile.write(str(i)+":"+str(wcet)+"\n")
    wfile.close

flst = read_file() 
for i in range(len(flst)):
    funcname = ((flst[i].split(":"))[-1]).rstrip()
    tp = ((flst[i].split(":"))[1])
    tsk = ((flst[i].split(":"))[0])
    filename = sys.argv[2]
    #print(funcname)
    if sys.argv[1] == "KTA":
        exe=". /opt/mcb32tools/environment && export KTA_WCET_RUNTIME_PATH=/vagrant/kta/runtime && /vagrant/kta/bin/kta wcet "+ filename + " " + funcname+ " -compile"
        #print(exe)
        op= subprocess.Popen(exe, shell=True, stdout=subprocess.PIPE).stdout.read()
        oplist=op.decode('utf8').split(" ")
        #print(op)
        wfile=open(tsk+".wcet", "w")
        wfile.write(tp+":"+oplist[3])
        wfile.close()

