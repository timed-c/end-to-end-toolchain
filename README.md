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
The Timed C e2e toolchain runs in a Vagrant environment. This makes the e2e toochain portable across different operating systems. This document describe how to install the e2e toolchain using Vagrant. This Vagrant setup is known to work on Ubuntu, macOS, and Windows machines.

### Installation using Vagrant 
1. **Install Vagrant** 
	
	Go to the link below (Vagrant website) and follow the instructions to install Vagrant 
			
			https://www.vagrantup.com/docs/installation
1. **Download Timed C E2E repo**
		
	Go to the link below (E2E on github) and clone the E2E repository.
	 
		https://github.com/timed-c/end-to-end-toolchain.git		
2. **Enter the working directory and fetch submodules**
	
		cd end-to-end-toolchain
		git submodule init
		git submodule update
		
   If you get a error on update please use the below command
		
		git submodule update --force --recursive --init --remote 
		
3. **Install E2E using Vagrant**
	 
	 Execute the following command. This usually takes a few minutes to complete. 

		vagrant up
	
		
### Setup Timed C E2E toolchain using Vagrant 
1. **SSH to the Vagrant environment** 
		
	Use the below command to work on the E2E toolchain environment. 
		
		vagrant ssh

2. **Install KTC** 
		
		cd /vagrant 
		sh ktc-install.sh
		cd /vagrant/ktc
		eval $(opam config env) && make
		cd ..

3. **Export path to E2E** 

	Use the following command to export path to e2e command. 

		export PATH=/vagrant/bin:$PATH

		
### Display e2e commands

1. **List all currently available e2e commands**
	
	Type the following on command-line. 
		
		e2e
	This will display the following 
	
		E2E - KTH's Timed C source-to-source compiler and end-to-end toolchain.

		usage: e2e <command> [<args>] [<options>]

		commands:
  		compile  Performs source-to-source transformation of Timed C program
  		wcet     Outputs the instrumented source-to-source transformed C program.
  		help     Prints out help about commands.
  		sens     Performs sensitivity analysis.
		Run 'e2e help <command>' to get help for a specific command.
		
To get help for a command, use `e2e help <command>`. For example, `kta help compile` will display all options accepted by compile command.

### Using e2e command for compiling and executing  a Timed C file 

We will compile a simple Timed C program `posix_example.c` available in `/vagrant/examples` folder. 

We start with explaning the `e2e compile` command. Typing `e2e help compile` displays the following 
	
		E2E - KTH's Timed C source-to-source compiler and end-to-end toolchain.	

		Usage: e2e compile [<files>] [<options>]

		Description:
  			Compile Timed C file to target specific C file.

		Options:
  			--posix                Compile Timed C code for POSIX compliant platform.
  			--static-analysis{KTA, OTAWA} <name of file>  
  								   Perform WCET computation of code fragments with hard deadline using the specified static analysis tool. Currently supported arguments are either OTAWA or KTA. Here, <name of file> is the file containing definition of function with hard deadline
  			--freertos             Compile Timed C code for freeRTOS platform
  			--exec                 Compiles the Timed C file and outputs the executable
  			--compiler <path_to_compiler>
                                   Path to cross compiler.
  			--run                  Compile and run
  			--runtime              Compile and run with runtime monitoring
  			--runtime-calculation  Compile and generate executable to compute execution time for runtime monitoring
  			--save <path_to_temp_folder>
                                   Specify path to folder to save generated files
 			--testing              Only supports testing log generation for runtime monitoring
                       

To compile `posix_example.c` we run the following command. Note that the tool will save the source-to-source transformed Timed C in `temp/`  (as temp is given as arguement to the `--save` option) 

	e2e compile /vagrant/examples/posix_example.c --save temp --posix


To compile and generate executable we run the following command with `--exec` option. The toolchain will create `a.out` in the current folder.

	e2e compile /vagrant/examples/posix_example.c --posix --exec


To compile and run `posix_example.c` we execute the following command with `--run` option. Note that the use of option `--save` will save the source-to-source transformed Timed C in `temp/`.

	e2e compile /vagrant/examples/posix_example.c --save temp --posix --run
	
<!--- To compile a Timed C code with hard deadline we  use the Timed C example in `examples/example-htp/htp_example.c` we execute the following command with `--static-analysis` option. Note that the use of option `--static-analysis` takes the tool and the function definition of the code-fragment with hard deadline. 

 	e2e compile /vagrant/examples/example-htp/htp_example.c --save temp --posix --static-analysis KTA nsichneu.c --->



### Using e2e for compiling and executing a Timed C file with profiling  

We will compile a simple Timed C program `profile_example.c` available in `/vagrant/examples` folder. 

We start with explaning the `e2e wcet` command. Typing `e2e help wcet` displays
	
	E2E - KTH's Timed C source-to-source compiler and end-to-end toolchain.

	Usage: e2e wcet [<files>] [<options>]

	Description:
  	Outputs instrumented C file for WCET computation.

	Options:
  	--posix                Generate instrumented code for POSIX compliant platform.
  	--freertos             Generate instrumented code for freeRTOS platform.
  	--timing-param         Complete timing traces is generated on execution of timing trace.
  	--timing-trace         Traces are generated with parameters.
 	--iter <value>         Number of iterations the instrumented program executes.
  	--exec                 Compiles the Timed C file and outputs the executable.
  	--compiler <path_to_compiler>
                           Path to cross compiler.
  	--run                  Compile and run.
  	--save <path_to_temp_folder>
                          Specify path to folder to save generated files

To compile and generate instrumented code using a buffer based implementation of  e2e. We execute the following command with `--timing-param` option. Note that the use of option `--save` will save the source-to-source transformed Timed C in `temp/`.


	e2e wcet /vagrant/examples/profile_example.c --save temp --posix --timing-param

To compile and generate the  instrumented executable of `profile_example.c` using a buffer based implementation of e2e, we execute the following command with `--exec` option. The toolchain will create `a.out` in the current folder.

	e2e wcet /vagrant/examples/profile_example.c --posix --timing-param --exec


To generate measurement-based trace of `profile_example.c`, we execute the following command with `--run` option. The generated traces with extension `*.ktc.trace` and are saved in the current directory 

	e2e wcet /vagrant/examples/profile_example.c --posix  --timing-param --run


### Performing sensitivity analysis  

We will perform sensitivity analysis of the `example.c`available in `/vagrant/examples/example-sens` folder. Note that the traces for this file is available in the same directory. 

We start with explaning the `e2e sens` command. Typing `e2e help sense` displays

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
 		
Note that e2e sens command requires all the specified options. The traces and the Timed C file are required to be in the same folder. To perform sensitivity analysis of the specified example we run 

	e2e sens example.c --trace-format param --policy EDF --epsilon 0.05 --util 0.98 --kfile klist
	
Note that traces were obtained using --timing-param option. 


