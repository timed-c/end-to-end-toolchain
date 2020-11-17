import re
import subprocess
import os
import sys
debug=False

def extract_function_name(s):
    n=(s.find("("))
    return(s[0:n])

def debug_print(a, b):
    if debug:
        print("*** DEBUG PRINT ***")
        print(a)
        print(b)

def extract_argument(s):
    return(extract_substring(s, "(", ")"))

def is_while(stm):
    word=stm.split()
    if "while(" in word[0]:
        return(True)
    return(False)

def extract_substring(s, first, last):
    try:
        start = s.rindex( first ) + len( first )
        end = s.rindex( last, start )
        return s[start:end]
    except ValueError:
        return ""

def get_wcet_kta(cf, filename):
    debug_print("get_wcet", cf)
    #TODO check if cf[0] is a function
    print(cf)
    if len(cf)==1:
        funccall=cf[0]
        funcname = extract_function_name(cf[0])
        arglist=extract_argument(cf[0])
    else:
        if (is_while(cf[0]) & (len(cf) <= 2)):
            funccall=cf[1]
            funcname = extract_function_name(cf[1])
            arglist=extract_argument(cf[1])
        elif (is_while(cf[0]) & (len(cf) > 2)): #TODO improve
            funccall=cf[2]
            funcname = extract_function_name(cf[2])
            arglist=extract_argument(cf[2])
        else:
            sys.exit("Not a function")
    arg=""
    if ((len(arglist)) > 0):
        arglist=arglist.split(",")
        for i in range(len(arglist)): 
            arg=arg+"a"+str(i)+"=["+str(arglist[i])+","+str(arglist[i])+"]"
        #TODO change absolute path
        print(arg)
        exe=". /opt/mcb32tools/environment && /vagrant/kta/bin/kta wcet "+ filename + funcname+ " -compile -args "+ arg
    else: 
        exe=". /opt/mcb32tools/environment && /vagrant/kta/bin/kta wcet "+ filename + funcname+ " -compile"
    print(exe)
    #exe= ". /opt/mcb32tools/environment && /home/saranya/Dokument/kta/kta/bin/kta exec "+filename+ " -compile -func " +funcname 
    #print exe
    op= subprocess.Popen(exe, shell=True, stdout=subprocess.PIPE).stdout.read()
    oplist=op.split(" ")
    print op
    return(oplist[3])
