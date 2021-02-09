import sys
import os
import subprocess

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

def task_name(tsk):
    debug_print("task list", tsk)
    tname=extract_substring(tsk[0], "task", "(")
    return(tname)

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

def write_src(kfile, word):
    kfile.write(word[0])
    kfile.write(",")

def write_bcet(kfile, word):
    kfile.write(word[1])
    kfile.write(",")

def write_jitter(kfile, word):
    kfile.write("356")
    kfile.write(",")

def write_abort(kfile, word):
    kfile.write(word[4])
    kfile.write(",")

def write_dst(kfile, word):
    kfile.write(word[5])


def write_wcet(kfile, word, wname_path, wname):
    if os.path.isfile(wname_path) == False:
        #print(wname_path, "  does not exists")
        kfile.write(word[2])
    else: 
        dst = word[5].replace('\n', '')
        wfile=open(wname, "r")
        wline=wfile.readlines()
        for i in range(0, len(wline)):
            elem = wline[i].split(":")
            #print(elem)
           # print(dst[0])
            if elem[0]==dst:
                wcet=int(int(elem[1])/900)
                kfile.write(str(wcet))
            else: 
                kfile.write(word[2])
    kfile.write(",")


    
timedcfile=sys.argv[1]
ifile=open(timedcfile, "r")
line=ifile.readlines()
tasks=get_task_list(line)
tsk_name=[]
for i in range(0,len(tasks)):
    tsk_name.append((task_name(tasks[i])).replace(" ", ""))
for i in range(0,len(tsk_name)):
    #print(tsk_name[i])
    wname = tsk_name[i]+".wcet"
    tname = tsk_name[i]+(".ktc.trace")
    wname_path="./"+wname;
    tname_path="./"+tname
    if os.path.isfile(tname_path) == False:
        sys.exit("Error: trace file for "+tname+" does not exist")
    tname_opt="ktc_"+tname
    rname="temp_"+tname
    exe = "cp "+tname+" "+tname_opt
    op= subprocess.Popen(exe, shell=True, stdout=subprocess.PIPE).stdout.read()
    #print(exe)
    tfile=open(tname_opt, "r")
    kfile=open(rname, "w")
    tline=tfile.readlines()
    #print(tline)
    kfile.write(tline[0])
    for j in range(1,len(tline)):
        word=(tline[j]).split(",")
        #print(word)
        write_src(kfile, word)
        write_bcet(kfile, word)
        write_wcet(kfile, word, wname_path, wname)
        write_jitter(kfile, word)
        write_abort(kfile, word)
        write_dst(kfile, word)
    kfile.close()
    tfile.close()
    cmd= 'cp '+rname+' '+tname 
    subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE).stdout.read()

