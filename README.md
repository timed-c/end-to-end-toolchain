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


## Installing and Running Timed C E2E toolchain
The Timed C e2e toolchain runs in a vagrant environment. This makes the e2e toochain portable across different operating systems. This document describe how to install the e2e toolchain as a docker  image. This  docker container  is known to work on Ubuntu, Linux, and Windows machines.

### Installing on Vagrant 
1. Clone from the Timed C E2E repo
		
		git clone https://github.com/saranya-natarajan/end-to-end-toolchain.git
		
2. Enter the working directory  and fetch submodules
	
		cd end-to-end-toolchain
		git submodule init
		git submodule update
If you get a error on update please use the below command
		
		git submodule update --force --recursive --init --remote 
3. Go to parent directory 

		vagrant up
		
### Setting up e2e toolchain 
1. SSH to vagrant environment using the below command
		
		vagrant ssh
		
2. Go to the main vagrant directory using the below command

		cd /vagrant
	
3. Export path to e2e bin using the below command

		export PATH=/vagrant/bin:$PATH
		
### Display e2e commands

The list of available e2e commands is shown by typing
	
		e2e
		
To get help for a command, write e2e help followed by the command. For example,

	kta help compile
	
will display all options accepted by compile, which performs source-to-source transformation of the input Timed C file.

### Compiling and executing a Timed C file 

We will compile a simple TimedC program posix_example.c that is available in the directory /vagrant/examples. 

	e2e help compile
which displays
	
	E2E - KTH's Timed C source-to-source compiler and end-to-end toolchain.

	Usage: ktc compile [<files>] [<options>]

	Description:
  	Compile Timed C file to target specific C file.

	Options:
  	--posix                Compile Timed C code for POSIX compliant platform.
  	--freertos             Compile Timed C code for freeRTOS platform
  	--exec                 Compiles the Timed C file and outputs the executable
  	--compiler <path_to_compiler>
                         Path to cross compiler.
  	--run                  Compile and run
	--save <path_to_temp_folder>
                         specify path to folder to save generated files

If we run

	e2e compile /vagrant/examples/posix_example.c --save temp --posix
the tool will save the source-to-source transformed Timed C in temp/ folder.

If we run

	e2e compile /vagrant/examples/posix_example.c --save temp --posix --exec
the tool will save the source-to-source transformed Timed C in temp/ folder and the executable a.out will be created in the current folder.

If we run

	e2e compile /vagrant/examples/posix_example.c --save temp --posix --run
the tool will save the source-to-source transformed Timed C in temp/ folder and will run the executable.


### Compiling and executing a Timed C file with profiling  

We will compile a simple TimedC program profile_example.c that is available in the directory /vagrant/examples. 

	e2e help wcet
which displays
	
	E2E - KTH's Timed C source-to-source compiler and end-to-end toolchain.

	Usage: e2e wcet [<files>] [<options>]

	Description:
  	Outputs instrumented C file for WCET computation.

	Options:
  	--posix                Compile Timed C code for POSIX compliant platform.
  	--freertos             Compile Timed C code for freeRTOS platform
  	--timing-param         Compile Timed C code for profiling (complete timing
                         trace).
  	--timing-trace         Compile Timed C code for profiling (only parameters).
  	--static-analysis      Perform WCET computation of code fragments with hard
                         deadline using the specified static analysis tool.
                         Currently supported arguments are either OTAWA or
                         KTA.
  	--iter<value>          Number of iterations the instrumented program
                         executes.
  	--exec                 Compiles the Timed C file and outputs the executable
  	--compiler <path_to_compiler>
                         Path to cross compiler.
  	--run                  Compile and run
  	--save <path_to_temp_folder>
                         specify path to folder to save generated files

If we run

	e2e wcet /vagrant/examples/profile_example.c --save temp --posix --timing-param
the tool will save the source-to-source transformed instrumented Timed C in temp/ folder.

If we run

	e2e wcet /vagrant/examples/profile_example.c --save temp --posix --timing-param --exec
the tool will save the source-to-source transformed instrumented Timed C in temp/ folder and the executable a.out will be created in the current folder.

If we run

	e2e wcet /vagrant/examples/profile_example.c --save temp --posix  --timing-param --run
the tool will execute the file and produce traces. The traces are files ending with extension .ktc.trace


### Performing sensitivity analysis  

We will perform sensitivity analysis for a Timed C with already generated trace in examples/example-sens 

	e2e help sens
which displays
E2E - KTH's Timed C source-to-source compiler and end-to-end toolchain.

	Usage: e2e sens [<files>] [<options>]

	Description:
  		Performs sensitivity analysis.

	Options:
  		--trace-format{param, trace}
  							 Specifies timing format. Specify param if profiling was done with --timing-param. trace if profiling was done with --timing-trace.
  		--epsilon            Epsilon resolution
  		--util               Maximum utilization
  		--policy{RM,EDF}     Specifies scheduling policy. RM for rate monotonic EDF for earliest deadline first
 		--kfile <filename>   Path to the csv file that list the name of the tasks,its k, and its limit of interest (task name,k,l)
 		
Note that e2e sens command requires all the specified options. The traces and the Timed C file are required to be in the same folder. To perform sensitivity analysis for the above specified example we run 

	e2e sens example.c --trace-format param --policy EDF --epsilon 0.05 --util 0.98 --kfile klist
	
Note that traces were obtained using --timing-param option. 


