# The Timed C E2E Toolchain
The Timed C E2E is a pragmatic toolchain that takes as input a Timed C program and performs temporal (schedulability and sensitivity) analysis on the program.  The Timed C E2E  toolchain integrates :

1. [KTC source-to-source compiler](https://github.com/timed-c/ktc): A source to source compiler for compiling Timed C program to target specific C code.
2. [Schedulability test tool ](https://github.com/brandenburg/np-schedulability-analysis): A tool that performs  schedulability tests for sets of non-preemptive jobs.
3. [Sensitivity analysis tool ](https://github.com/saranya-natarajan/end-to-end-toolchain/tree/master/sensitivity-analysis): A tool that computes the weakly hard constraint of a system w.r.t WCET margins.


 The Timed C E2E toolchain takes as input a Timed C program and does the following steps in order: 
 
  1.	_KTC Profiling_ : performs measurement-based WCET estimations using the KTC profiler. The KTC profiler is an extension of the KTC compiler.  It takes as input a Timed C program and generates an instrumented C program. It then automatically compiles this instrumented C code and calculates the WCET.  It uses this information to generate input for the next step. 
  2.   _Schedulability Test_ : uses this estimates to perform schedulability test.  The  tool also supports uniprocessor analysis with abort actions, which forcefully stops and discards a job's execution at its deadline. 
  3.  _Sensitivity Analysis_ : based on the ouput from the previous step it performs temporal sensitivity analysis. It calculates the maximum scaling factor and _M_ for a given _k_

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
If you get a error on update please use the below command
		
		git submodule update --force --recursive --init --remote 
		
3. Build the E2E docker image. This will take few minutes. 
		
		docker build --no-cache --tag=e2e .

## Updating the Timed C E2E Toolchain
Note : do this only after your initial installation is done successfully.

1. Pull from the Timed C E2E repo

		git pull

3. Enter the working directory  and fetch update submodules

		git submodule update

2. Re-build the E2E docker image

		<path-to-end-to-end-toolchain>/end2end --end
		docker build --no-cache --tag=e2e .

## Running the toolcahin

Run the docker image 
	
	<path-to-end-to-end-toolchain>/end2end --init
	

Compiling timed C code for freeRTOS platform.
	
		<path-to-end-to-end-toolchain>/bin/ktc <file.c> --freertos
		
Compiling timed C code for POSIX platform

		<path-to-end-to-end-toolchain>/bin/ktc <file.c> --posix
		
Compiling timed C code for profiling (complete timing trace). Here iter is the number of iteration. Output is cil.c file

		<path-to-end-to-end-toolchain>/bin/ktc <file.c> --posix --timing-trace <iter>

Compiling timed C code for profiling (only parameters). Here iter is the number of iteration. Output is cil.c file

		<path-to-end-to-end-toolchain>/bin/ktc <file.c> --posix --timing-param <k> <iter>
	
Compile and run timed C code for profiling . Here iter is the number of iteration. Output is cil.c file

		<path-to-end-to-end-toolchain>/bin/ktc <file.c> --posix-run --timing-param <k> <iter>
		
Run sensitivity analysis

		<path-to-end-to-end-toolchain>/bin/sens <file> <trace-format> <kfile> <epsilon> <utilization_cap>  --util <policy>

where, trace-format is --param or --trace, epsilon is epsilon resolution, utilization_cap is the cap on system utilization and policy is either 0 for edf and 1 for RM. kfile is a csv file that list the name of a tasks, its k, and its limit of interest (task name,k,l),

## The Format of the Output File
Below is an example depicting M v/s WCET margins for a given input 

	Misses 	WCET Margin
	0		0.419789309955
	3		0.508166006787
	5		0.530260180995
	7		0.59654270362
	19		0.640731052036
	22		0.662825226244
	26		0.684919400452

