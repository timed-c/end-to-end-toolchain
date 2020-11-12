import re
import subprocess
import os
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
    if "{" in word:
        return(True)
    return(False)

def there_exist_close_bracket(stm):
    word=stm.split()
    if "}" in word:
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
            bracket = 1;
            for j in range(i, len(line)):
                bracket = update_bracket_count(bracket, line[j])
                if bracket==0:
                    i=j+1
                    tlist.append(line[j])
                    break
                tlist.append(line[j])
            tasks.append((tlist))
    return(tasks)


def start_of_func(stm,fname):
    if fname in stm:
        return(True)
    return(False)

def get_function_list(line, nme): 
    tasks=[]
    tlist=[]
    for i in range(0, len(line)):
        word=line[i].split()
        if (start_of_func(line[i], nme)):
            tlist=[]
            bracket = 1;
            for j in range(i, len(line)):
                bracket = update_bracket_count(bracket, line[j])
                if bracket==0:
                    i=j+1
                    tlist.append(line[j])
                    break
                tlist.append(line[j])
            tasks.append((tlist))
    return(tasks)

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
    if ("htp" in strng) or ("hdelay" in strng):
        return(True)
    return(False)

def is_timingpoint(stm):
    if (is_stp(stm)) or (is_ftp(stm)) or (is_htp(stm)):
        return(True)

def get_kind(stm):
    if (is_htp(stm)):
        return("hard")
    if (is_stp(stm)):
        return("soft")
    if (is_ftp(stm)):
        return("firm")

def extract_code_fragment(stm):
    cf=[]
    knd="None"
    for i in range(0, len(stm)):
        if is_timingpoint(stm[i]):
            knd = get_kind(stm[i])
            i=i+1
            break
        cf.append(stm[i])
    return(cf,i,knd)

#Extract and copy function to wcet C file
def extract_function(all_files):
    for i in range(len(all_files)):
        fp=open(all_files[i], "r")
        fcontent=[]
        lst=fp.readlines()
        func =  get_function_list(lst, "fact") 
        print(func)
        print("extract_function")


def write_to_file(cf):
    func_fp=open("wcet_file.c", "w")
    func_fp.write("#include<stdio.h>\n")
    func_fp.write("void wcet_func(){\n")
    for i in range(len(cf)):
        func_fp.write("\t")
        func_fp.write(cf[i])
    func_fp.write("}\n")
    func_fp.write("\nvoid main(){\n")
    func_fp.write("\t wcet_func();")
    func_fp.write("\n}")
    func_fp.close()

def get_wcet(cf, filename):
    print(cf)
    #TODO check if cf[0] is a function
    if len(cf)==1:
        write_to_file(cf)
        funcname = extract_function_name(cf[0])
        arglist=extract_argument(cf[0])
        arglist=arglist.split(",")
        #func=extract_function(all_files, funcname)
        #write_to_file(cf, func[0])
    #else:
    #TODO support for all argument type
     #   for i in range(len())
        #fnfp.write("wcet_func.c", "")    
    arg=""
    for i in range(len(arglist)): 
        arg=arg+"a"+str(i)+"=[0,"+str(arglist[i])+"] "
        #TODO change absolute path
    exe= ". /opt/mcb32tools/environment && /home/saranya/Dokument/kta/kta/bin/kta exec "+filename+ " -compile -func " +funcname + " -args "+ arg 
    exe_wcet= ". /opt/mcb32tools/environment && export KTA_WCET_RUNTIME_PATH=/home/saranya/Dokument/kta/kta/runtime && /home/saranya/Dokument/kta/kta/bin/kta wcet " +filename+ " -compile -optimize 3" +funcname + " -args "+ arg 
    print exe_wcet
    op= subprocess.Popen(exe_wcet, shell=True, stdout=subprocess.PIPE).stdout.read()
    oplist=op.split(" ")
    print op
    #print op[0][0]
    return(oplist[-3])

def task_to_formal_tfg(task,pset,fset, fname):
    debug_print("formal tfg task", task)
    tid=0;
    pset.append([0, 0, 0, 0, 0, "NA", "NA"])
    for i in range(1, len(task)): 
        tid=tid+1
        if is_timingpoint(task[i]):
            tA = get_arrival_time(task[i])
            tD = get_deadline(task[i])
            tj= "NA"
            tr="NA"
            p=[tid, tA, tD, tj, tr]
            pset.append(p)
        else:
            #print(i)
            #print(task[i])
            (clist,j,knd)=extract_code_fragment(task[i:len(task)])
            #TODO make better : do not include end of function as a cf
            if clist[0]!="}\n":
                i=j
                tB=0
                if knd == "hard":
                    tW=get_wcet(clist,fname)
                else: 
                    tW=-1
                f=[tid, tB, tW, clist]
                fset.append(f)
    debug_print("pset", pset)
    debug_print("fset", fset)
    return(pset, fset)

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

fname="input.c"
funcfile="func.c"
ifile=open(fname, "r")
line=ifile.readlines()
dname=fname+".dot"
tasks=get_task_list(line)
#func_fp=open("func", "w")
#func_fp.write("#include<stdio.h>\n")
filelist = ["func.c"]
extract_function(filelist)
fp=open(dname, "w")
for i in range(len(tasks)):
    (pset, fset)=task_to_formal_tfg(tasks[i], [], [],funcfile)
    tsk_name=task_name(tasks[i])
    task_to_tfg(pset, fset, fp, tsk_name)
    print(fset)
fp.close()
#func_fp.close()
#display_dot_file(dname)
ifile.close()


#. /opt/mcb32tools/environment &&  /home/saranya/Dokument/kta/kta/bin/kta
