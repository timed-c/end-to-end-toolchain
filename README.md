## The E2E Toolchain
 E2E is pragmatic tool that takes as input a Timed C program, performs a measurement-based WCET estimation, uses this estimates to perform schedulability test, and performs temporal sensitivity analysis to calculate the number of deadline met (_n_) in any _k_ consecutive execution of a task when the WCET is increased by a certain scaling factor.

 The various steps in e2e are:
 (i) KTC Instrumentation : This is a measurement-based WCET profiler. It takes as input a Timed C program and generates an instrumented C program. It also automatically compiles this instrumented C code and calculates the WCET. Finally, it uses this information to generate input to the schedulability test (next step). The KTC profiler is an extension of the KTC compiler. KTC is a source-to-source compiler for the Timed C programming language.
 (ii) Schedulability Test : It performs schedulability tests for sets of non-preemptive jobs.
 (iii) (m, k) - Sensitivity Analysis :   This is a temporal sensiticty analysis tool that scales up the current WCET and reports the number of deadline met for a given k.

 For further details refer to
 KTC : [Github](https://github.com/timed-c/ktc)
 Schedulability Test (older version): [Github](https://github.com/brandenburg/np-schedulability-analysis)
 Timed C: S. Natarajan and D. Broman, [“Timed C : An Extension to the C Programming Language for Real-Time System”](https://people.kth.se/~dbro/papers/natarajan-broman-2018-timed-c.pdf), In 2018 IEEE Real-Time and Embedded Technology and Applications Symposium (RTAS). IEEE, 2018.

## Installing e2e toolchain
The e2e toolchain is packed as an docker image. This makes the e2e toochain portable across different OSes. This document describe how to install the e2e toolchain as a docker container image. This e2e docker container image is known to work on Ubuntu, Linux, and Windows machines.
Prerequisite : Docker Software

### Step 1: Installing Docker
If the docker sofware is installed on your machine you can go to step 2.
##### Windows
For windows follow instruction at
https://docs.docker.com/docker-for-windows/install/

##### Ubuntu
For Ubuntu follow instruction at
https://docs.docker.com/install/linux/docker-ce/ubuntu/

##### Installing Docker on Mac OS
For Mac OS follow instruction at
https://docs.docker.com/docker-for-mac/install/

### Step 2: Installing the E2E Docker Container Image

    git clone https://github.com/saranya-natarajan/end-to-end-toolchain.git
    cd end-to-end-toolchain
    git submodule init
    git submodule update
    docker build --tag=e2e .

#### Step 3: Testing the Installation
    docker run -it e2e
    cd profile-test
    ./run-end.sh test1.c

Output:
...
Completed

Note, that the above execution takes place within a docker container. You can exit the docker container by typing the command _exit_ .

#### Updating E2E Docker Container Image
Note : do this only after your intial installation is done successfully.

    git pull
    docker build --tag=e2e .

#### Running the e2e tool

Step 1: Writing Timed C program
The file _template.c_ in the end-to-end-toolchain folder contains all the required header to compile a Timed C program. Copy this file to your working directory. Make a copy of this file to <filename.c>. Write your Timed C program and save.

Step 2: Intializing the e2e tool.
This step is required because the e2e tool runs as a docker container. This command is only executed once at the begining.

    <path_to_end_to_end_toolchain>/end2end --init

Step 3: Running the e2e toolchain.
This command runs the e2e toolchain. The input is a timed C program and a number _k_.

    <path_to_end_to_end_toolchain>/end2end --run <filename.c> -k <number>

The option --run takes as argument a timed C program. It ouputs a file called <filename.c.output>. The option -k takes a number as an argument, where _k_ is the size of the consecutive window. THe default value of _k_ is 3. The contents of <filename.c.output> is described later.

Step 4: Terminating the e2e toolchain.
This command kills and removes the e2e docker image. It is recommended to run this command only once after finish all work on the e2e toolchain. Note, it is not required to run this command between every execution. This command is executed at the very end after completing the e2e session. This helps in cleaning up the memory used by the e2e container.

    <path_to_end_to_end_toolchain>/end2end --e

#### The Format of the Output File
Below is an example of an output file
```
1   1 : SCHEDULABLE
2   5.0672325449 : NOT SCHEDULABLE
3   3.03361627245 : SCHEDULABLE
4   4.05042440868 : SCHEDULABLE
5   4.55882847679 : SCHEDULABLE
6   4.81303051084 : NOT SCHEDULABLE
7   4.68592949382 : SCHEDULABLE
8   4.74948000233 : NOT SCHEDULABLE
9   4.71770474807 : NOT SCHEDULABLE
10  Maximum scaling factor is : 4.68592949382
11  Range : [4.68592949382, 5.0672325449]
12  (n, k) analysis
13  Scaling Factor :4.87658101936
14  task id :3 n :4 k :4
15  task id :2 n :3 k :4
16  task id :1 n :0 k :4
...
```

(i) Line 1 to 10 in this file displays all the scaling factor that sensitivity analysis uses to iteratively derive a maximum value. Information about whether this scalin factor is schedulable is displayed.
(ii) Line 10 is the maximum computed scaling factor.
(ii) Line 11 displays a range of scaling factor that the (_n,k_) analysis considers.
(iv) Line 13 to Line 16 describes the scaling factor and the (_n,k_) values for the different tasks.
