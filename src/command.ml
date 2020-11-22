open Ustring.Op
open Printf

(* ---------------------------------------------------------------------*)
(* Types of options. *)
type compOpTypes = 
  |OpPosix
  |OpFreertos 
  |OpExec
  |OpCompile 
  |OpFolder
  |OpParam
  |OpTrace
  |OpStaticAnalysis
  |OpIter
  |OpSparam
  |OpStrace 
  |OpEpsilon
  |OpUtil
  |Opkfile
  |Oppolicy
  |OputilizationCap
  |OpRun

let extra_options = 
   [(OpExec,     Uargs.No, us"--exec",     us"",
       us"Compiles the Timed C file and outputs the executable");
   (OpCompile,   Uargs.Str, us"--compiler",     us" <path_to_compiler>",
       us"Path to cross compiler.");
   (OpRun,   Uargs.No, us"--run",     us"",
       us"Compile and run");
   (OpFolder, Uargs.Str, us"--save", us" <path_to_temp_folder>", us"specify path to folder to save generated files")]
   


(* ---------------------------------------------------------------------*)
let get_timedc_filename ops args =
  let sargs = List.map Ustring.to_utf8 args in
  (match sargs with 
  | [fname] -> fname 
  | _ -> raise (Uargs.Error (us"Timed C file missing.")))


(* ---------------------------------------------------------------------*)
let compile_options =
   [(OpPosix, Uargs.No,  us"--posix",  us"",
       us"Compile Timed C code for POSIX compliant platform.");
   (OpFreertos, Uargs.No,  us"--freertos",  us"",
       us"Compile Timed C code for freeRTOS platform")]
   @ extra_options 

(* ---------------------------------------------------------------------*)
let sens_options =
   [(OpSparam, Uargs.No,  us"--param",  us"",
       us"Profiling was done with --timing-param");
   (OpStrace, Uargs.No,  us"--trace",  us"",
       us"Profiling was done with --timing-trace");

   (OpEpsilon, Uargs.No,  us"--epsilon",  us"",
       us"Epsilon resolution");
   (OpUtil, Uargs.Int,  us"--util",  us"<value>",
       us"Specifies dystem utilization cap");
   (Oppolicy, Uargs.No,  us"--static-analysis",  us"",
       us"Specified scheduling policy.\n
          RM for rate monotonic and EDF for earliest deadline first");
   (Opkfile, Uargs.Int,  us"--kfile",  us"<path to file>",
       us" Path to the csv file that list the name of the tasks, its k, and its limit of interest (task name,k,l)")]


(* ---------------------------------------------------------------------*)
let wcet_options =
   [(OpPosix, Uargs.No,  us"--posix",  us"",
       us"Compile Timed C code for POSIX compliant platform.");
   (OpFreertos, Uargs.No,  us"--freertos",  us"",
       us"Compile Timed C code for freeRTOS platform");
   (OpParam, Uargs.No,  us"--timing-param",  us"",
       us"Compile Timed C code for profiling (complete timing trace).");
   (OpTrace, Uargs.No,  us"--timing-trace",  us"",
       us"Compile Timed C code for profiling (only parameters).");
   (OpStaticAnalysis, Uargs.No,  us"--static-analysis",  us"",
       us"Perform WCET computation of code fragments with hard deadline using the specified static analysis tool.\n
          Currently supported arguments are either OTAWA or KTA.");
   (OpIter, Uargs.Int,  us"--iter",  us"<value>",
       us"Number of iterations the instrumented program executes.")]
   @ extra_options 
(* ---------------------------------------------------------------------*)

let parse_ops_get_filename args options = 
    let (ops, args) = Uargs.parse args options in
    let timedc_filename = get_timedc_filename ops args in
    (ops, args, timedc_filename)

(* ---------------------------------------------------------------------*)
let compile_command args = 
    let (ops, args, timedc_filename) = parse_ops_get_filename args compile_options in 
    let posix = Uargs.has_op OpPosix ops in
    let freertos = Uargs.has_op OpFreertos ops in
    let save =
    if Uargs.has_op OpFolder ops
    then let dir = Uargs.str_op OpFolder ops |> Ustring.to_utf8 in 
         let dir_cmd = "[ ! -d "^dir^" ] && mkdir -p "^dir in 
         let _ = Sys.command dir_cmd in
         dir
    else "." in
    let compiler = 
            if (not(Uargs.has_op OpCompile ops) && (Uargs.has_op OpPosix ops)) 
            then "gcc " 
            else (Uargs.str_op OpCompile ops |> Ustring.to_utf8) in 
    let cilfile =  if save = "." 
                    then (List.nth (String.split_on_char '.' (List.nth (List.rev (String.split_on_char '/' timedc_filename)) 0))0)^(".cil.c")
                    else save^"/"^(List.nth (String.split_on_char '.' (List.nth (List.rev (String.split_on_char '/' timedc_filename)) 0))0)^(".cil.c") in 
    (if posix then
            let bash_command = ("/vagrant/ktc/bin/ktc --enable-ext0 -w --save-temps="^(save)^" "^(timedc_filename)) in 
            let _ = Sys.command bash_command in ());
    (if freertos then
            let bash_command = ("/vagrant/ktc/bin/ktc --enable-ext1 --save-temps="^(save)^" "^(timedc_filename)) in
            let _ = Sys.command bash_command in ());
   (if Uargs.has_op OpExec ops then
        let bash_command = compiler^" "^cilfile^" /vagrant/ktc/timedc-lib/src/fprofile.c /vagrant/ktc/timedc-lib/src/cilktc_lib.c -I/vagrant/ktc/timedc-lib/src/ -lm -lpthread -lrt -w" in
        (*let bash_command = compiler^" "^cilfile^" -lktc -lm -lpthread -lrt -w -L/vagrant/libs -no-pie -w" in*)
           let _ = Sys.command bash_command in ());
   (if Uargs.has_op OpRun ops then
           let bash_command = compiler^" "^cilfile^" /vagrant/ktc/timedc-lib/src/fprofile.c /vagrant/ktc/timedc-lib/src/cilktc_lib.c -I/vagrant/ktc/timedc-lib/src/ -lm -lpthread -lrt -w" in
           let _ = Sys.command bash_command in 
           let _ = Sys.command "sudo ./a.out" in ());
   us("")

(* ---------------------------------------------------------------------*)
let wcet_command args = 
    let (ops, args, timedc_filename) = parse_ops_get_filename args wcet_options in 
    let trace_format = if Uargs.has_op OpPosix ops  
                       then (if Uargs.has_op OpTrace ops 
                             then "--enable-ext2" 
                             else "--enable-ext4")
                        else (if Uargs.has_op OpTrace ops 
                             then "--enable-ext3" 
                             else "--enable-ext5") in
    let save = if Uargs.has_op OpFolder ops 
               then Uargs.str_op OpFolder ops |> Ustring.to_utf8
               else "." in
    let compiler = 
            if (not(Uargs.has_op OpCompile ops) && (Uargs.has_op OpPosix ops)) 
            then "gcc " 
            else (Uargs.str_op OpCompile ops |> Ustring.to_utf8) in 
    let cilfile =  if save = "." 
                    then (List.nth (String.split_on_char '.' (List.nth (List.rev (String.split_on_char '/' timedc_filename)) 0))0)^(".cil.c")
                    else save^"/"^(List.nth (String.split_on_char '.' (List.nth (List.rev (String.split_on_char '/' timedc_filename)) 0))0)^(".cil.c") in   
    let iter = string_of_int(
            if ((Uargs.has_op OpIter)) ops 
            then (Uargs.int_op OpIter ops) else
            100) in 
    let bash_command = ("/vagrant/ktc/bin/ktc "^trace_format^" --save-temps="^(save)^" "^(timedc_filename)^" -w") in 
    let _ = Sys.command bash_command  in
    (if Uargs.has_op OpExec ops then
           let bash_command = (if Uargs.has_op OpTrace ops 
            then compiler^" "^cilfile^" /vagrant/ktc/timedc-lib/src/fprofile.c /vagrant/ktc/timedc-lib/src/cilktc_lib.c -I/vagrant/ktc/timedc-lib/src/ -lm -lpthread -lrt -w -lplogs -L/vagrant/libs -no-pie"
            else compiler^" "^cilfile^" /vagrant/ktc/timedc-lib/src/fprofile.c /vagrant/ktc/timedc-lib/src/cilktc_lib.c -I/vagrant/ktc/timedc-lib/src/ -lm -lpthread -lrt -w -lmplogs -L/vagrant/libs -no-pie") in 
           let _ = Sys.command bash_command in ());
   (if Uargs.has_op OpRun ops then
           let bash_command = (if Uargs.has_op OpTrace ops 
            then compiler^" "^cilfile^" /vagrant/ktc/timedc-lib/src/fprofile.c /vagrant/ktc/timedc-lib/src/cilktc_lib.c -I/vagrant/ktc/timedc-lib/src/ -lm -lpthread -lrt -w -lplogs -L/vagrant/libs -no-pie && sudo ./a.out "^iter
            else compiler^" "^cilfile^" /vagrant/ktc/timedc-lib/src/fprofile.c /vagrant/ktc/timedc-lib/src/cilktc_lib.c -I/vagrant/ktc/timedc-lib/src/ -lm -lpthread -lrt -w -lmplogs -L/vagrant/libs -no-pie && rm -f *.ktc.trace && sudo ./a.out 3 "^iter) in 
           let _ = Sys.command bash_command in ());
   us("")


(* ---------------------------------------------------------------------*)
let sens_command args = 
    let _ = uprint_string (us "sens option") in 
    us "sens option"

(* ---------------------------------------------------------------------*)
let help command toptext =
  (* Function that takes care of the string generation *)
  let pstr command desc options =     
    Some (toptext ^. us"\n" ^.
    us"Usage: ktc " ^. us command ^. us" [<files>] [<options>]\n\n" ^.
    us"Description:\n" ^. us desc ^. us"\n" ^.
    us"Options: \n" ^.
    Uargs.optionstext options)
  in

  (* Select the main command *)
  match command with
  | "compile" -> 
       pstr "compile" 
         ("  Compile Timed C file to target specific C file.\n")
        compile_options         
  | "wcet" -> 
       pstr "wcet" 
         ("  Outputs instrumented C file for WCET computation.\n")
        wcet_options         
  | "sens" -> 
       pstr "sens" 
       ("  Performs sensitivity analysis.\n")
        sens_options
  | _ -> None


