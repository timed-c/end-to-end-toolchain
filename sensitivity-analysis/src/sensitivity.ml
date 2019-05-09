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

let rec iter_get_number_of_task n lst =
    match lst with
    | [] -> n
    | _ -> let id = List.nth (List.hd lst) 0 in
            iter_get_number_of_task (Pervasives.max n id) (List.tl lst)


let get_number_of_task () =
    let ifile = read_data_input "job.csv" in
    let noheader = List.tl ifile in
    let original_csv =  List.map (fun a -> List.map (int_of_string) [a.tskid; a.jobid; a.rmin; a.rmax; a.cmin; a.cmax; a.dl; a.priority]) noheader in
    let n = iter_get_number_of_task 0 original_csv in
    n

let rec print_delta_min_max delta_min delta_max delta_sup i =
    let _ = if (i = 0) then
        begin
            uprint_string (us "Misses \t"); uprint_string (us "Delta Min\t"); uprint_string (us "Delta Max \n")
        end in
    if (Array.length delta_min > i) then
        begin
            if ((delta_min.(i) <> delta_sup) & (delta_max.(i) <> 0.0)) then
                begin
                    uprint_int i; uprint_string (us "\t"); uprint_float delta_min.(i); uprint_string (us "\t"); uprint_float delta_max.(i); uprint_endline (us "")
                end;
            print_delta_min_max delta_min delta_max delta_sup (i+1)
        end


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
    List.map (fun [tid; jid; misses] -> [(int_of_string tid); (int_of_string jid); (int_of_string misses)]) lst
   (* List.map2 (fun a b  -> [int_of_string a.tid; int_of_string a.jid; ((int_of_string b.dl) - (int_of_string a.wcct))]) rta ip*)


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
    (*let _ = uprint_string (us "k_window :") in
    let _ = uprint_int k; uprint_string (us " ");uprint_int i; uprint_string (us "\n") in
    let _ = uprint_int (i mod (len)) ;uprint_string (us "\n") in*)
    match k with
    |0 ->  kwin
    |_ ->  let l = (i mod (len)) in k_window llst (k-1) (i+1) ((List.nth llst l) :: kwin) len

let rec calculate_misses_k llst k i m len =
    (*let _ = uprint_string (us "calculate_misses_k") in
    let _ = (uprint_int len); (uprint_string (us "\n")) in*)
    if (i < len) then
        let kwin = (k_window llst k i [] len) in
        (*let _ = uprint_int i in*)
        let mprime = Pervasives.max m (List.fold_left (fun b a -> if ((List.nth a 2) < 0) then (b+1) else (b+0)) 0 (kwin)) in
        calculate_misses_k llst k (i+1) mprime len
    else
        m

let rec calculate_misses_for_each_task i num_task m klist olst =
    if (i <= num_task) then
        (*let _ = uprint_string (us "calculate_misses_for_each_task : ") in
        let _ = uprint_int i; (uprint_string (us "\n")) in *)
        let llst = List.filter (fun a -> (List.hd a = i)) olst in
        let k = List.nth klist (i-1) in
        let mprime = calculate_misses_k llst k 0 0 (List.length llst) in
            calculate_misses_for_each_task (i+1) num_task (m + mprime) klist olst
    else
        m

let calculate_misses delta klist =
    (*let _ = uprint_string (us "calculate_misses for"); uprint_float delta; uprint_endline (us "") in*)
    let _ = scale_input delta in
    let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r -c job.csv > output" in
    let joblist =  create_mk_analysis_csv () in
    let num_task = List.length klist in
    let m = calculate_misses_for_each_task 1 num_task 0 klist joblist in
    (*uprint_string (us "number of misses :"); uprint_int m; uprint_endline (us "");*) m

let rec bsearch delta_min_lst delta_max_lst l u epsilon klist =
    (*let _ = uprint_string (us "bsearch") in
    let _ = uprint_int l; uprint_int u; uprint_endline (us "") in*)
    if (delta_min_lst.(u) -. delta_max_lst.(l) < epsilon) then
        (delta_min_lst, delta_max_lst, u)
    else
        let delta_mid = (delta_min_lst.(u) +. delta_max_lst.(l)) /. 2.0 in
        let m = calculate_misses delta_mid klist in
        let _ = delta_min_lst.(m) <- (Pervasives.min delta_min_lst.(m) delta_mid) in
        let _ = delta_max_lst.(m) <- (Pervasives.max delta_max_lst.(m) delta_mid) in
        let ub = if (l = m) then u else m in
        (*(uprint_string (us "ub"); uprint_int ub; uprint_endline (us ""));*)
        (bsearch delta_min_lst delta_max_lst l ub epsilon klist)


let rec min_index delta_sup delta_min m cmin i =
    if (i < m) then
        if (delta_min.(i) < delta_sup) then
            min_index delta_sup delta_min m (Pervasives.min i m) (i+1)
        else
            min_index delta_sup delta_min m cmin (i+1)
    else
        (*(uprint_string (us "min_index"); uprint_int cmin; uprint_endline (us ""));*) cmin

let rec iter_bsearch delta_min_lst delta_max_lst delta_sup i m epsilon klist =
    let _ = uprint_string (us "iter_bsearch :") in
    let _ = uprint_int i; uprint_endline (us "") in
    if (i < m ) then
        let u =  min_index delta_sup delta_min_lst m m (i+1) in
        (*let _ = uprint_float (delta_min_lst.(u)); uprint_endline (us "") in*)
        let (delta_min, delta_max, iprime) = bsearch delta_min_lst delta_max_lst i u epsilon klist in
        iter_bsearch delta_min delta_max delta_sup iprime m epsilon klist
    else
        (delta_min_lst, delta_max_lst)


let sensitivity =
    let num_task = get_number_of_task () in
    (*let _ = uprint_int num_task; uprint_string (us "sensitivity\n") in*)
    let klist = Array.to_list ((Array.make num_task (int_of_string (Sys.argv.(1))))) in
    let epsilon = float_of_string (Sys.argv.(2)) in
    let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r -c job.csv > output" in
    let delta_sup = max_initial_upper_bound () in
    (*let _ = uprint_float delta_sup in*)
    let delta_inf = 0.0 in
    let m = calculate_misses delta_sup klist in
    let delta_min_lst = Array.make (m+1)delta_sup  in
    let delta_max_lst = Array.make (m+1) delta_inf in
    let _ = delta_min_lst.(0) <- delta_inf in
    let _ = delta_max_lst.(m) <- delta_sup in
    let _ = uprint_int m; uprint_float (delta_min_lst.(m)); uprint_endline (us "") in
    let (delta_min, delta_max) = iter_bsearch delta_min_lst delta_max_lst delta_sup 0 m epsilon klist in
    print_delta_min_max delta_min delta_max delta_sup 0; ()








