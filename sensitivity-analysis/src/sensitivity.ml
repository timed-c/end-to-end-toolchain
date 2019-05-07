open Printf
open Csv
open Ustring.Op
open Sys

exception Sense of string


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

type mk_analysis =
{
    task_id : string;
    job_id : string;
    miss : string;
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
                      | _ -> failwith "read_data_output: incorrect file output")

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

let calculate_leeway l1 l2 =
    let lway = (float_of_string l1.dl) -. (float_of_string l2.wcct)  in
    let delta = ((float_of_string l1.cmax) +. lway) /. (float_of_string l1.cmax) in
    [l1.tskid; l2.jid; (string_of_float delta)]


let scale_input alpha =
    let inp = (read_data_input "input") in
    let header = List.map (fun a -> [a.tskid; a.jobid; a.rmin; a.rmax; a.cmin;
    a.cmax; a.dl; a.priority]) ([List.hd inp]) in
    let noheader = List.tl inp in
    let original_csv =  List.map (fun a -> [a.tskid; a.jobid; a.rmin; a.rmax; a.cmin;
    a.cmax; a.dl; a.priority]) inp in
    let newip = List.map (fun a -> [a.tskid; a.jobid; a.rmin; string_of_int
    (int_of_float ((float_of_string a.rmin) +. (((float_of_string a.rmax) -.(float_of_string a.rmin)) *. alpha))); a.cmin; (string_of_int (int_of_float ((alpha *. (float_of_string a.cmax))))); a.dl; a.priority]) noheader in
    let nip = List.append header newip in
    Csv.save "job.csv" nip

let create_mk_analysis_csv () =
    let ip = List.tl (read_data_input "job.csv") in
    let rta = List.tl (read_data_rta "job.rta.csv") in
    let lst = List.map2 (fun a b -> if ((a.tid = b.tskid) & (a.jid = b.jobid)) then
                                        [a.tid; a.jid; string_of_int ((int_of_string b.dl) - (int_of_string a.wcct))]
                                    else
                                        [] ) rta ip in
    let header = ["Task ID"; "Job ID"; "MISS"] in
    let _ = Csv.save "job.mk" (header :: lst) in
    List.map2 (fun a b  -> [int_of_string a.tid; int_of_string a.jid; ((int_of_string b.dl) - (int_of_string a.wcct))]) rta ip


let max_initial_upper_bound () =
    let ip = List.tl (read_data_input "job.csv") in
    let rta = List.tl (read_data_rta "job.rta.csv") in
    let _ =  create_mk_analysis_csv () in
    let lst = List.map2 (calculate_leeway) ip rta in
    let _ = Csv.save "check" lst in
    let t = List.map (function [ti; ji; lw] -> {ti; ji; lw}) lst in
    let minlw = List.fold_right min (List.map (fun a -> (float_of_string a.lw)) t) 1000000000000.0 in
    minlw

let findSchedulable ()  =
    let op = read_data_output "output" in
    let elem = List.hd op in
    (if (elem.is_schedulable = "1") then
        (uprint_endline ( us " : SCHEDULABLE"))
    else
        (uprint_endline (us " : NOT SCHEDULABLE")));
    elem.is_schedulable

let rec k_window llst k i kwin len =
    match k with
    |0 -> kwin
    |_ -> k_window llst (k-1) (i+1) ((List.nth llst (i mod len)) :: kwin) len

let rec calculate_misses_k llst k i m len =
    if (i < len) then
        let mprime = Pervasives.max m (List.fold_left (fun b a -> if (List.nth a 2 < 0) then (b+1) else (b+0)) 0 (k_window llst k i [] len)) in
        calculate_misses_k llst k (i+1) mprime len
    else
        m

let rec calculate_misses_for_each_task i num_task m klist olst =
    if (i < num_task) then
        let llst = List.map (fun a -> if (List.hd a = i) then a else []) olst in
        let k = List.nth klist i in
        let mprime = calculate_misses_k llst k i 0 (List.length llst) in
            calculate_misses_for_each_task (i+1) num_task (m + mprime) klist olst
    else
        m

let calculate_misses delta klist =
    let _ = scale_input delta in
    let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r -c job.csv > output" in
    let joblist =  create_mk_analysis_csv () in
    let num_task = List.length klist in
    let m = calculate_misses_for_each_task 0 num_task 0 klist joblist in
    m

let rec bsearch delta_min_lst delta_max_lst l u epsilon klist =
    if (delta_min_lst.(u) -. delta_max_lst.(l) < epsilon) then
        (delta_min_lst, delta_max_lst, u)
    else
        let delta_mid = (delta_min_lst.(u) +. delta_max_lst.(l)) /. 2.0 in
        let m = calculate_misses delta_mid klist in
        let _ = Pervasives.min delta_min_lst.(m) delta_mid in
        let _ = Pervasives.max delta_max_lst.(m) delta_mid in
        let ub = if (l = m) then u else m in
        bsearch delta_min_lst delta_max_lst l ub epsilon klist


let rec min_index delta_sup delta_min m cmin i =
    if (i < m) then
        if (delta_min.(i) < delta_sup) then
            min_index delta_sup delta_min m (Pervasives.min i m) i+1
        else
            min_index delta_sup delta_min m cmin i+1
    else
        cmin

let rec iter_bsearch delta_min_lst delta_max_lst delta_sup i m epsilon klist =
    if (i < m ) then
        let u =  min_index delta_sup delta_min_lst m m i in
        let (delta_min, delta_max, iprime) = bsearch delta_min_lst delta_max_lst i u epsilon klist in
        iter_bsearch delta_min delta_max delta_sup iprime m epsilon klist
    else
        (delta_min_lst, delta_max_lst)


let sensitivity =
    let klist = Array.to_list (Array.make (int_of_string (Sys.argv.(1))) (int_of_string (Sys.argv.(2)))) in
    let epsilon = 0.05 in
    let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r -c job.csv > output" in
    let delta_sup = max_initial_upper_bound () in
    let _ = uprint_float delta_sup in
    let delta_inf = 0.0 in
    let m = calculate_misses delta_sup klist in
    let delta_min_lst = Array.make m delta_sup  in
    let delta_max_lst = Array.make m delta_inf in
    let _ = delta_min_lst.(0) <- delta_inf in
    let _ = delta_max_lst.(m) <- delta_sup in
    let (delta_min, delta_max) = iter_bsearch delta_min_lst delta_max_lst delta_sup 0 m epsilon klist in
    ()








