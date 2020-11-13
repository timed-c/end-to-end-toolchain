import re
import subprocess
import os
import sys
# read from input Timed c file
debug=False

def debug_print(a, b):
    if debug:
        print("*** DEBUG PRINT ***")
        print(a)
        print(b)

def extract_substring(s, first, last):
    try:
        start = s.rindex( first ) + len( first )
        end = s.rindex( last, start )
        return s[start:end]
    except ValueError:
        return ""

def extract_argument(s):
    return(extract_substring(s, "(", ")"))

def extract_function_name(s):
    n=(s.find("("))
    return(s[0:n])

def there_exist_open_bracket(stm): 
    word=stm.split()
    for i in range(0, len(word)):
        if "{" in word[i]:
            return(True)
    return(False)

def there_exist_close_bracket(stm):
    word=stm.split()
    for i in range(0, len(word)):
        if "}" in word:
            return(True)
    return(False)

def there_exist_htp(stm):
    word=stm.split()
    for i in range(0, len(word)):
        if "htp" in word[i]:
            return(True)
    return(False)

def update_bracket_count(bracket, line):
    if there_exist_open_bracket(line):
        bracket = bracket+1;
    if there_exist_close_bracket(line):
        bracket=bracket-1;
    return(bracket)

def start_of_task(stm):
    word=stm.split()
    if "task" in word:
        return(True)
    return(False)

def get_task_list(line): 
    tasks=[]
    tlist=[]
    for i in range(0, len(line)):
        word=line[i].split()
        if (start_of_task(line[i])):
            tlist=[]
            bracket = 0;
            for j in range(i, len(line)):
                bracket = update_bracket_count(bracket, line[j])
                if bracket==0:
                    i=j+1
                    tlist.append(line[j])
                    break
                tlist.append(line[j])
            tasks.append((tlist))
    debug_print("get_task_list", tasks)
    return(tasks)

def get_task_list_with_htp(line):
    tlist=get_task_list(line)
    tlist_htp=[]
    for i in range(0, len(tlist)):
        tlines=tlist[i]
        ret = False
        for j in range(0, len(tlines)):
            ret = there_exist_htp(tlines[j])
            if ret==True:
                tlist_htp.append(tlines)
                break
    return(tlist_htp)


def get_arrival_time(stm):
    if not is_timingpoint(stm):
        raise Exceeption("Not a timing point")
    arg=(extract_argument(stm)).split(",")
    return(arg[0])

def get_deadline(stm):
    if not is_timingpoint(stm):
        raise Exceeption("Not a timing point")
    arg=(extract_argument(stm)).split(",")
    if ("fdelay" in stm) or ("sdelay" in stm):
        return(arg[0])
    else:
        return(arg[1])
    
def is_stp(strng):
    if ("stp" in strng) or ("sdelay" in strng):
        return(True)
    return(False)

def is_ftp(strng):
    if ("ftp" in strng) or ("fdelay" in strng):
        return(True)
    return(False)

def is_htp(strng):
    if ("htp" in strng) or ("sdelay" in strng):
        return(True)
    return(False)

def is_timingpoint(stm):
    if (is_stp(stm)) or (is_ftp(stm)) or (is_htp(stm)):
        return(True)

def is_while(stm):
    word=stm.split()
    if "while(" in word[0]:
        return(True)
    return(False)


def extract_code_fragment(stm):
    cf=[]
    ret=False
    for i in range(0, len(stm)):
        if is_timingpoint(stm[i]):
            if (is_htp(stm[i])):
                ret=True
            break
            i=i+1
        #if (is_while(stm[i]) == False):
        cf.append(stm[i])
    return(cf,i,ret)

def get_wcet_kta(cf, filename, fnfp):
    debug_print("get_wcet", cf)
    #TODO check if cf[0] is a function
    #print(cf)
    print("get_wcet", filename)
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
    fnfp.write("\n")
    fnfp.write(funccall)
    fnfp.write("\n}")
    arg=""
    if ((len(arglist)) > 0):
        arglist=arglist.split(",")
        for i in range(len(arglist)): 
            arg=arg+"a"+str(i)+"=["+str(arglist[i])+","+str(arglist[i])+"]"
        #TODO change absolute path
        #print(arg)
        exe=". /opt/mcb32tools/environment && /vagrant/kta/bin/kta wcet "+ filename + funcname+ " -compile -args "+ arg
    else: 
        exe=". /opt/mcb32tools/environment && /vagrant/kta/kta/bin/kta wcet "+ filename + funcname+ " -compile"
    #print(exe)
    #exe= ". /opt/mcb32tools/environment && /home/saranya/Dokument/kta/kta/bin/kta exec "+filename+ " -compile -func " +funcname 
    print exe
    op= subprocess.Popen(exe, shell=True, stdout=subprocess.PIPE).stdout.read()
    oplist=op.split(" ")
    print op
    return(oplist[3])

def get_wcet_otawa(cf, filename, fnfp):
    debug_print("get_wcet", cf)
    #TODO check if cf[0] is a function
    #print(cf)
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
    fnfp.write("\n")
    fnfp.write(funccall)
    fnfp.write("\n}")

def task_to_formal_tfg(task,pset,fset, fname, wcet_tool):
    debug_print("task_to_formal_tfg", task)
    fcounter=0;
    tid=0
    tpid=0
    pset.append([0, 0, 0, 0, 0, "NA", "NA"])
    #for i in range(1, len(task)):
    i=0
    j=1
    hset=[-1]
    while i < (len(task)-1):
        i=i+j
        j=1
        debug_print("i", i)
        tid=tid+1
        if is_timingpoint(task[i]):
            #print(i, task[i])
            tA = get_arrival_time(task[i])
            tD = get_deadline(task[i])
            tj= "NA"
            tr="NA"
            p=[tid, tA, tD, tj, tr]
            pset.append(p)
            tpid=tpid+1
            if(is_htp(task[i]) == False):
                hset.append(-1)
        else:
            #print(i, task[i:len(task)])
            (clist,j, hard)=extract_code_fragment(task[i:len(task)])
            #TODO make better : do not include end of function as a cf
            debug_print("clist", clist)
            #print("j", j)
            if clist[0]!=" }\n":
                #i=i+j
                tB=0
                tW=0
                if (hard):
                    fcounter=fcounter+1;
                    finame="wcet_main_"+str(fcounter)+".c"
                    fn_fp=open(finame, "w")
                    fn_fp.write("#include<stdio.h>\n"+"#include\""+funcfile+"\""+"\nvoid main(){")
                    if (wcet_tool == "KTA"):
                        tW=get_wcet_kta(clist,fname,fn_fp)
                    else:
                        tW=get_wcet_otawa(clist,fname,fn_fp)
                    hset.append(tW)
                    fn_fp.close() 
                f=[tid, tB, tW, clist]
                fset.append(f)
    debug_print("pset", pset)
    debug_print("fset", fset)
    return(pset, fset, hset)

def vertex_id(lst):
    return(lst[0])

def task_name(tsk):
    debug_print("task list", tsk)
    tname=extract_substring(tsk[0], "task", "(")
    return(tname)

def task_to_tfg(pset, fset, f, tname):
    f.write("digraph G {\n label=\""+tname+"\";\nlabelloc=\"t\";\n")
    for i in range(len(pset)):
        f.write(str(vertex_id(pset[i]))+"[shape=circle];\n")
    for i in range(len(fset)):
        f.write(str(vertex_id(fset[i]))+"[shape=square];\n")
    for i in range((len(pset)+len(fset)-1)):
        # TODO code if-else and loop
        f.write(str(i)+" -> "+str(i+1)+";\n")
    f.write("}")

def display_dot_file(dname):
    cmd= 'dot -Tps '+dname+' -o '+dname+".ps"
    subprocess.call([cmd], shell=True)
    subprocess.call(['gnome-open', dname+".ps"])


#timedcfile="simple-example.c"
#funcfile="func.c"
#wcet_tool="OTAWA"
timedcfile=sys.argv[1]
funcfile=sys.argv[2]
wcet_tool=sys.argv[3]
ifile=open(timedcfile, "r")
line=ifile.readlines()
dotfile=timedcfile+".dot"
tasks=get_task_list_with_htp(line)
debug_print("main", tasks)
fp=open(dotfile, "w")
for i in range(len(tasks)):
    (pset, fset, hset)=task_to_formal_tfg(tasks[i], [], [],funcfile, wcet_tool)
    tsk_name=(task_name(tasks[i])).replace(" ", "")
    #task_to_tfg(pset, fset, fp, tsk_name)
    #print(tsk_name)
    rhset=hset[::-1]
    wfile=open(tsk_name+".wcet", "w")
    for i in range(0,len(hset)):
        if(hset[i] != -1):
            wfile.write(str(i)+","+str(hset[i])+"\n")
    #print("final result", tsk_name, hset)
fp.close()
#display_dot_file(dname)
ifile.close()



#. /opt/mcb32tools/environment &&  /home/saranya/Dokument/kta/kta/bin/kta
