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
  |OpFormat 
  |OpEpsilon
  |OpUtil
  |OpKfile
  |OpPolicy
  |OpRun
  |OpPath

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
    (OpStaticAnalysis, Uargs.StrList,  us"--static-analysis",  us"",
       us"Perform WCET computation of code fragments with hard deadline using the specified static analysis tool.\n
          Currently supported arguments are either OTAWA or KTA.");
   (OpFreertos, Uargs.No,  us"--freertos",  us"",
       us"Compile Timed C code for freeRTOS platform")]
   @ extra_options 

(* ---------------------------------------------------------------------*)
let sens_options =
   [(OpFormat, Uargs.Str,  us"--trace-format",  us"{param, trace}",
       us"Specifies timing format. \n
           param if profiling was done with --timing-param.\n
           trace if profiling was done with --timing-trace.");
   (OpEpsilon, Uargs.Str,  us"--epsilon",  us"",
       us"Epsilon resolution");
   (OpUtil, Uargs.Str,  us"--util",  us"",
       us"Maximum utilization");
   (OpPolicy, Uargs.Str,  us"--policy",  us"{RM,EDF}",
       us"Specifies scheduling policy.\n
          RM for rate monotonic \n
          EDF for earliest deadline first"); 
   (OpKfile, Uargs.Str,  us"--kfile",  us"<filename>",
       us" Path to the csv file that list the name of the tasks, its k, and its limit of interest (task name,k,l)")]


(* ../../sensitivity-analysis/bin/sensitivity klist.csv 0.05 0.98 1 *)
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
    let stwcet = if Uargs.has_op OpStaticAnalysis ops 
               then List.map (fun a -> Ustring.to_utf8 a) (Uargs.strlist_op OpStaticAnalysis ops)
               else [] in
    (*let tool = List.nth stwcet 0 in
    let funcname = List.nth stwcet 1 in
    let _ = printf "%s %s" tool funcname in
    let _ = exit 0 in *)
    let _ = printf "len %d" (List.length stwcet) in
    let _ = if ((List.length stwcet) > 1) then 
             (let htp_compatiable = Wcet.main_wcet timedc_filename (List.nth stwcet 0) (List.nth stwcet 1) in
              if (htp_compatiable == false) then ((printf "Hard deadline can not be guaranteed"); exit 0)) in 
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
let sens_command args = 
    let (ops, args, timedc_filename) = parse_ops_get_filename args sens_options in
    let trace_format =  Uargs.str_op OpFormat ops |> Ustring.to_utf8 in
    let ktc_opt = (if (trace_format = "param")   
                 then "--enable-ext5" 
                 else "--enable-ext3") in
    let jobset_format =  Uargs.str_op OpPolicy ops |> Ustring.to_utf8 in
    let jobset = (if (jobset_format = "EDF")   
                 then "job_edf.csv" 
                 else "job_fp.csv") in
    let klist = Uargs.str_op OpKfile ops |> Ustring.to_utf8 in
    let util = Uargs.str_op OpUtil ops |> Ustring.to_utf8 in
    let epsilon = Uargs.str_op OpEpsilon ops |> Ustring.to_utf8 in
    let bash_command = "/vagrant/ktc/bin/ktc "^(ktc_opt)^" "^(timedc_filename)^" -D _Float128=double -w" in
    let _ = Sys.command bash_command in
    let bash_command = "cp "^jobset^" job.csv && cp job.csv input && cp action.csv orginal_action" in 
    let _ = Sys.command bash_command in 
    let bash_command = "/vagrant/sensitivity-analysis/bin/sensitivity "^klist^" "^epsilon^" "^util^" 1" in
    let _ = Sys.command bash_command in
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
    let bash_command = ("/vagrant/ktc/bin/ktc "^trace_format^" --save-temps="^(save)^" "^(timedc_filename)^" -D _Float128=double -w") in 
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
(*let sens_command args = 
    (*let (ops, args, timedc_filename) = parse_ops_get_filename args wcet_options in *)
    us ("Needs some bug fixing")*)



(* ---------------------------------------------------------------------*)
let help command toptext =
  (* Function that takes care of the string generation *)
  let pstr command desc options =     
    Some (toptext ^. us"\n" ^.
    us"Usage: e2e " ^. us command ^. us" [<files>] [<options>]\n\n" ^.
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


