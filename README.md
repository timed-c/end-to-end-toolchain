# The Timed C E2E Toolchain
The Timed C E2E is a pragmatic toolchain that takes as input a Timed C program and performs temporal (schedulability and sensitivity) analysis on the program.  The Timed C E2E  toolchain integrates :

1. [KTC source-to-source compiler](https://github.com/timed-c/ktc): A source to source compiler for compiling Timed C program to target specific C code.
2. [Schedulability test tool ](https://github.com/brandenburg/np-schedulability-analysis): A tool that performs  schedulability tests for sets of non-preemptive jobs.
3. [Temporal sensitivity analysis tool ](https://github.com/saranya-natarajan/end-to-end-toolchain/tree/master/sensitivity-analysis): A tool that computes the maximum scaling factor by which the WCET of all tasks in a program can be scaled up and still be schedulable. The tool also computes the number of deadlines met for a given number of consecutive of the task. The term _n_ and _k_ are used to represent the number of deadlines met and consecutive windows, respectively.
 
 The Timed C E2E toolchain takes as input a Timed C program and does the following steps in order: 
 
  1.	_KTC Profiling_ : performs measurement-based WCET estimations using the KTC profiler. The KTC profiler is an extension of the KTC compiler.  It takes as input a Timed C program and generates an instrumented C program. It then automatically compiles this instrumented C code and calculates the WCET.  It uses this information to generate input for the next step. 
  2.   _Schedulability Test_ : uses this estimates to perform schedulability test.  The  tool also supports uniprocessor analysis with abort actions, which forcefully stops and discards a job's execution at its deadline. 
  3.  _Sensitivity Analysis_ : based on the ouput from the previous step it performs temporal sensitivity analysis. It calculates the maximum scaling factor and _n_ for a given _k_

References:
 1. _Timed C_ ::  S. Natarajan and D. Broman, [“Timed C : An Extension to the C Programming Language for Real-Time System”](https://people.kth.se/~dbro/papers/natarajan-broman-2018-timed-c.pdf), In 2018 IEEE Real-Time and Embedded Technology and Applications Symposium (RTAS). IEEE, 2018.
 2. _Schedulability Test_ :: M. Nasri and B. Brandenburg, [“An Exact and Sustainable Analysis of Non-Preemptive Scheduling”](https://people.mpi-sws.org/~bbb/papers/pdf/rtss17.pdf) , Proceedings of the 38th IEEE Real-Time Systems Symposium (RTSS 2017), pp. 12–23, December 2017.
    M. Nasri, G. Nelissen, and B. Brandenburg, [“A Response-Time Analysis for Non-Preemptive Job Sets under Global Scheduling”](http://drops.dagstuhl.de/opus/volltexte/2018/8994/pdf/LIPIcs-ECRTS-2018-9.pdf), Proceedings of the 30th Euromicro Conference on Real-Time Systems (ECRTS 2018), pp. 9:1–9:23, July 2018.


## Installing Timed C E2E toolchain
The Timed C e2e toolchain is packed as an docker image. This makes the e2e toochain portable across different operating systems. This document describe how to install the e2e toolchain as a docker  image. This  docker container  is known to work on Ubuntu, Linux, and Windows machines.


### Installing Docker
If the docker sofware is installed on your machine please skip this step. Otherwise, follow the instruction below

##### For Windows

https://docs.docker.com/docker-for-windows/install/

##### For Ubuntu

https://docs.docker.com/install/linux/docker-ce/ubuntu/

##### For Mac OS

https://docs.docker.com/docker-for-mac/install/

### Installing the Timed C E2E Docker  Image

1. Clone from the Timed C E2E repo
		
		git clone https://github.com/saranya-natarajan/end-to-end-toolchain.git
		
2. Enter the working directory  and fetch submodules
	
		cd end-to-end-toolchain
		git submodule init
		git submodule update
		
3. Build the E2E docker image. This will take few minutes. 
		
		docker build --tag=e2e .

## Updating the Timed C E2E Toolchain
Note : do this only after your initial installation is done successfully.

1. Pull from the Timed C E2E repo

		git pull

2. Re-build the E2E docker image

		docker build --tag=e2e .

## Running the EMSOFT examples

The examples for the EMSOFT paper are in <path-to-end-to-end-toolchain>/emsoft-eval folder. In this folder soft.c is soft periodic, soft-offset.c is soft perioidic with offset, gmf.c is gmf, and gmf-offset.c is gmf with offset. To run these examples go to the directory and follow the following steps 

1.  Intializing the Timed C E2E tool.
This step is required because the tool runs as a docker container.  This command starts the docker container in the background that is used to run the tool. Noe that this command is only executed once at the begining.

		 <path-to-end-to-end-toolchain>/end2end --init

2. Instrumentation for own system
This command runs the e2e toolchain. The input is a timed C program 

  
  		  <path-to-end-to-end-toolchain>/end2end -p <file.c>
  		  
3. Instrumentation for Raspberry Pi system
 The input is a timed C program. Use option -m or --rasp 

  
  		  <path-to-end-to-end-toolchain>/end2end -m <file.c> 
  		  
4. For periodic task set run the following command once traces are generated. Here n is number of tasks and k is the number of windows 

		<path-to-end-to-end-toolchain>/end2end --sensp <file.c>  n k
		
4. For gmf task set run the following command once traces are generated. Here n is number of tasks and k is the number of windows

		<path-to-end-to-end-toolchain>/end2end -sensf <file.c>  n k
 
 
5. Terminating the e2e toolchain.
This command kills and removes the Timed C E2E docker container (created using --init). It is recommended to run this command only after finish all work on the  toolchain. Note, it is not required to run this command between every execution. This helps in cleaning up the memory used by the  docker container.

		<path_to_end_to_end_toolchain>/end2end --end
		
The output can be found in file k_(no-of-windows-specified)_.For example, for k=3 the output is in k_3.
		
## Running the Timed C E2E tool

1.  Writing Timed C program
The file _template.c_ in the end-to-end-toolchain folder contains all the required header to compile a Timed C program. Copy this file to your working directory. Make a copy of this file to <filename.c>. Write your Timed C program and save. A number of program examples can be found at  
		
		<path-to-end-to-end-toolchain>/profile-test

2.  Intializing the Timed C E2E tool.
This step is required because the tool runs as a docker container.  This command starts the docker container in the background that is used to run the tool. Noe that this command is only executed once at the begining.

		 <path-to-end-to-end-toolchain>/end2end --init

3. Running the Timed C E2E toolchain.
This command runs the e2e toolchain. The input is a timed C program and a number _k_.

  
  		  <path-to-end-to-end-toolchain>/end2end --run <filename.c> -k <number>

The option --run takes as argument a timed C program. It ouputs a file called `<filename.c.output>`. The option -k takes a number as an argument, where _k_ is the size of the consecutive window. The default value of _k_ is 3. The contents of  `<filename.c.output>` is described later.

4. Terminating the e2e toolchain.
This command kills and removes the Timed C E2E docker container (created using --init). It is recommended to run this command only after finish all work on the  toolchain. Note, it is not required to run this command between every execution. This helps in cleaning up the memory used by the  docker container.

		<path_to_end_to_end_toolchain>/end2end --end
		

## The Format of the Output File
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

1. Line 1 to 10 in this file displays all the scaling factor that sensitivity analysis uses to iteratively derive a maximum value. Information about whether this scaling factor is schedulable is displayed.
2.  Line 10 in this file is the maximum computed scaling factor.
3. Line 11 displays a range of scaling factor that the (_n,k_) analysis considers
4.  Line 13 to Line 16 in this file describes  (_n,k_) values for the different tasks for the given scaling factor.