open Printf
open Csv
open Sys
open Array


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

type kind_info =
{
    tname : string;
    fid : string;
    fkind: string;
}


let read_data_input fname =
  Csv.load fname
  |> List.map (function [tskid; jobid; rmin; rmax; cmin; cmax; dl; priority] ->
          {tskid; jobid; rmin; rmax; cmin; cmax; dl; priority}
                      | _ -> failwith "read_data_input: incorrect file input")

let read_data_rta fname =
  Csv.load fname
  |> List.map (function [tid; jid; bcct; wcct; bcrt; wcrt] ->
          {tid; jid; bcct; wcct; bcrt; wcrt}
                      | _ -> failwith "read_data_rta: incorrect file rta")
 
let read_data_kind fname =
  Csv.load fname
  |> List.map (function [tname; fid; fkind] ->
                  {tname; fid; fkind}
                      | _ -> failwith "read_data_kind: incorrect file kind")


let rec make_task_id_list len tlst nlst = 
    match tlst with
    |h::rest -> (make_task_id_list (len-1) rest ((len, h.tname, h.fid, h.fkind) :: nlst))
    |[] -> nlst

let rec print_kind_task_id_list tlst =
    match tlst with 
    |(id, name, jid, knd):: rst -> (printf "(%d, %s, %s, %s)" id name jid knd);(print_kind_task_id_list rst)
    |[] -> ()


let find_job_id mkid hid = 
        if mkid == 0 then 0 else (hid mod mkid)

let rec check_list tlst mklist =
    match tlst with 
    | (hid, hname, hjid, jknd) :: rst -> let res = List.for_all (fun (a,b,c) -> if ((a = hid) && ((find_job_id b (int_of_string hjid))) = 0) then  (c > 0) else true) mklist in
                                        if (res == false) then false else (check_list rst mklist)
    |[] -> true
    
let make_htp_list tlst = 
    let htlist = List.filter (fun (a,b,c,d) -> d = "hdelay") tlst in 
    htlist


let create_mk_list () =
    let ip = List.tl (read_data_input "job_edf.csv") in
    let rta = List.tl (read_data_rta "job_edf.rta.csv") in
    let lst = List.map2 (fun a b -> if ((a.tid = b.tskid) && (a.jid = b.jobid)) then
                                        [a.tid; a.jid; string_of_int ((int_of_string b.dl) - (int_of_string a.wcct))]
                                    else
                                        [] ) rta ip in
    let header = ["Task ID"; "Job ID"; "MISS"] in
    let _ = Csv.save "job.mk" (header :: lst) in
    List.map (fun [tid; jid; misses] -> ((int_of_string tid), (int_of_string jid), (int_of_string misses))) lst


let make_task_kind_list ()  = 
    let tl = (read_data_kind "jobkind.csv") in
    let len = List.length (tl) in
    let tl_id = make_task_id_list len tl [] in
    (*let _ = print_kind_task_id_list tl_id in*)
    let hlst = make_htp_list tl_id in 
    let mklst = create_mk_list () in
    let res = check_list hlst mklst in
    if res then false else true

let main_wcet timedcfile tool funcfile = 
   (*let timedcfile = Sys.argv.(1) in
   let tool = Sys.argv.(2) in
   let funcfile = Sys.argv.(3) in*)
   let _ = Sys.command ("/vagrant/ktc/bin/ktc --enable-ext0 -w "^timedcfile) in 
   let _ = Sys.command ("python /vagrant/static-analysis/calculate_wcet.py "^tool^" "^funcfile) in
   let _ = Sys.command ("python /vagrant/static-analysis/make_trace.py "^timedcfile) in 
   let _ = Sys.command ("/vagrant/ktc/bin/ktc --enable-ext5 "^timedcfile^" -D _Float128=double -w") in
   let _ = Sys.command ("/vagrant/np-schedulability-analysis/build/nptest -r job_edf.csv -c -a action.csv -p pred.csv -l 1800") in
   let _ = Sys.command ("rm *.csv") in
   let _ = Sys.command ("rm *.dot") in
   let _ = Sys.command ("rm *.json") in
   let misses = make_task_kind_list () in 
   not misses
   (*let _ = if misses then (printf "no misses") else (printf "misses") in ()*)
