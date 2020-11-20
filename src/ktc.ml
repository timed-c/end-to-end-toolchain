(** 
    KTC - KTH's Timed C source-to-source compiler and end-to-end toolchain

    module: Main

    This is the main file for the KTC compiler and the end-to-end toolchain. 
*)

open Printf
open Ustring.Op


(* ---------------------------------------------------------------------*)
(* The top text message *)
let top_text =     
  us"KTC - KTH's Timed C source-to-source compiler and end-to-end toolchain.\n" 

  
(* ---------------------------------------------------------------------*)
(* The main help menu that displays all available commands. *)
let print_main_help() =
 top_text ^. us"\n" ^.
 us"usage: ktc <command> [<args>] [<options>] \n\n" ^.
 us"commands:\n" ^.
 us"  compile  Performs source-to-source transformation of Timed C program\n" ^.
 us"  wcet     Outputs the instrumented source-to-source transformed C program.\n" ^. 
 us"  help     Prints out help about commands.\n" ^.
 us"  sens     Performs sensitivity analysis.\n" ^.  
 us"Run 'ktc help <command>' to get help for a specific command.\n"
 |> uprint_endline

    
(* ---------------------------------------------------------------------*)
(* Handle the top commands of kta. *)      
let main =
  try 
    match Array.to_list Sys.argv with
    (* Commands *)
    | _::"compile"::args   -> Command.compile_command args |> uprint_endline
    | _::"wcet"::args     -> Command.wcet_command args |> uprint_endline
    | _::"sens"::args -> Command.sens_command args |> uprint_endline
    (* Help *) 
    | _::"help"::args -> 
      (match args with 
      | ["help"] -> print_main_help()
      | [c] -> 
        (match Command.help c top_text with
        | Some t -> uprint_endline t
        | None -> "Unknown command '" ^ c ^ "'." |> print_endline)
      | _ -> print_main_help())
      
    (* Cannot find the command *)
    | _::c::ls -> "Unknown command '" ^ c ^ "'." |> print_endline

    (* Print out the main help menu *)
    | _ -> print_main_help()

  with
    (* Print out error message *)
    Uargs.Error s -> uprint_endline s
