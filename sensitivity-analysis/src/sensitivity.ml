open Printf
open Csv
open Ustring.Op
open Sys

type output_info =
{
  file : string;
  is_schedulable : string;
  jobs : string;
  state : string;
  edges: string;
  expl : string;
  cpu : string;
  mem : string;
  timeout : string;
  processor : string;
}

type rta_info =
{
    tid : string;
    jid: string;
    bcct : string;
    wcct : string;
    bcrt : string;
    wcrt : string;
}

type input_info =
{
    tskid : string;
    jobid : string;
    rmin : string;
    rmax : string;
    cmin : string;
    cmax : string;
    dl : string;
    priority : string;
}

type analysis_format =
{
        ti : string;
        ji : string;
        lw : string;
}

let read_data_output fname =
  Csv.load fname
  |> List.map (function [file; is_schedulable; jobs; state; edges; expl; cpu;
  mem; timeout; processor] -> {file; is_schedulable; jobs; state; edges; expl; cpu;
  mem; timeout; processor}
                      | _ -> failwith "read_data: incorrect file output")

let read_data_input fname =
  Csv.load fname
  |> List.map (function [tskid; jobid; rmin; rmax; cmin; cmax; dl; priority] ->
          {tskid; jobid; rmin; rmax; cmin; cmax; dl; priority}
                      | _ -> failwith "read_data: incorrect file input")

let read_data_rta fname =
  Csv.load fname
  |> List.map (function [tid; jid; bcct; wcct; bcrt; wcrt] ->
          {tid; jid; bcct; wcct; bcrt; wcrt}
                      | _ -> failwith "read_data: incorrect file rta")

let calculate_leeway l1 l2 =
    let lway = (float_of_string l1.dl) -. (float_of_string l2.wcct) in
    let delta = ((float_of_string l1.cmax) +. lway) /. (float_of_string l1.cmax) in
    [l1.tskid; l2.jid; (string_of_float delta)]

let min a b =
    let aint = float_of_string a in
    if (aint < b) then aint else b

let scale_input alpha =
    let inp = (read_data_input "input") in
    let header = List.map (fun a -> [a.tskid; a.jobid; a.rmin; a.rmax; a.cmin;
    a.cmax; a.dl; a.priority]) ([List.hd inp]) in
    let noheader = List.tl inp in
    let _ = uprint_endline (us "Orginal CSV") in
    let original_csv =  List.map (fun a -> [a.tskid; a.jobid; a.rmin; a.rmax; a.cmin;
    a.cmax; a.dl; a.priority]) inp in
    let _ = Csv.print original_csv in
    let newip = List.map (fun a -> [a.tskid; a.jobid; a.rmin; a.rmax; a.cmin;
    (string_of_int (int_of_float ((alpha *. (float_of_string a.cmax))))); a.dl; a.priority]) noheader in
    let nip = List.append header newip in
    let _ = uprint_endline (us "Scaled CSV") in
    let _ = Csv.print nip in
    Csv.save "input_scaled.csv" nip


let initial_high () =
    let ip = List.tl (read_data_input "input") in
    let rta = List.tl (read_data_rta "output.rta") in
    let lst = List.map2 (calculate_leeway) ip rta in
    let _ = Csv.save "check" lst in
    let t = List.map (function [ti; ji; lw] -> {ti; ji; lw}) lst in
    let minlw = List.fold_right min (List.map (fun a -> a.lw) t)
    1000000000000.0 in
    minlw


let findSchedulable ()  =
    let op = read_data_output "output" in
    let elem = List.hd op in
    if (elem.is_schedulable = "1") then (uprint_endline ( (us (elem.file) )^.(us
    ":") ^.( us "SCHEDULABLE"))) else
        (uprint_endline ((us elem.file)^. (us ":")^.(us "NOT SCHEDULABLE"))); elem.is_schedulable
(*
let rec binary_search value low high init_high =
    if (high -. low > 0.05) then (
    let _ = uprint_endline (ustring_of_float value) in
    let _ = scale_input value in
    let _ = Sys.command "../build/nptest -r input_scaled.csv > output" in
    let is = findSchedulable () in
    if (is = "0") then
        (let vl = ((low +. high) /. (2.0)) in
            binary_search vl low vl high)
    else
        (let v = ((init_high +. high) /. (2.0)) in
        binary_search v high
        v init_high))
    else
        ()
*)

let rec binary_search low high =
    if ((high -. low) > 0.05) then (
        let value = (low +. high) /. 2.0 in
        let _ = uprint_endline (ustring_of_float low) in
        let _ = uprint_endline (ustring_of_float high) in
        let _ = uprint_endline (ustring_of_float value) in
        let _ = scale_input value in
        let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r input_scaled.csv > output" in
        let is = findSchedulable () in
        if (is = "0") then
            binary_search low value
        else
        binary_search value high)
    else
        low


let sensitivity =
    let high = initial_high () in
    let low = 1.0 in
    let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r job.csv > output" in
    let is = findSchedulable () in
    let _ = uprint_endline (ustring_of_float high) in
    let _ = scale_input high in
    let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r input_scaled.csv > output" in
    let ist = findSchedulable () in
    if (is = "1") then (uprint_endline (ustring_of_float (binary_search low high)))



