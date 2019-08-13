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

type action_format =
{
    atid : string;
    ajid : string;
    atmin : string;
    atmax : string;
    acmin : string;
    acmax : string;
}

type utilization_format =
{
    utaskid  : string;
    uarrival : string;
    ujitter  : string;
    ubcet    : string;
    uwcet    : string;
    udeadline: string;
    ukind    : string;
}

type imm_format =
{
        itskid : string;
        ijobid : string;
        irmin : int;
        icmax : int;
        idl : int;
        iwcct : int;
}

let sa_time = ref 0

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

let read_data_action fname =
  Csv.load fname
  |> List.map (function [atid; ajid; atmin; atmax; acmin; acmax] ->
          {atid; ajid; atmin; atmax; acmin; acmax}
                      | _ -> failwith "read_data_action: incorrect file rta")

let uniq lst =
  let unique_set = Hashtbl.create (List.length lst) in
  List.iter (fun x -> Hashtbl.replace unique_set x ()) lst;
  Hashtbl.fold (fun x () xs -> x :: xs) unique_set []


let rec calculate_utilization task_names tlist util =
    match task_names with
    | tname :: rest -> let tname_list = List.filter (fun a -> (List.hd a) = tname) tlist in
                       let tname_no_offset = List.filter (fun a -> (int_of_string (List.nth a 1)) <> 0) tname_list in
                       let sum_period = List.fold_left (fun a b -> a + (int_of_string (List.nth b 1))) 0 tname_no_offset in
                       let sum_bcet =  List.fold_left (fun a b -> a + (int_of_string (List.nth b 4))) 0 tname_no_offset in
                       let new_util = util +. (float_of_int sum_bcet) /. (float_of_int sum_period) in
                       calculate_utilization rest tlist new_util
    |[] -> util

let calculate_system_utilization () =
    let ulist = Csv.load "input.csv" in
    let task_list = List.map (fun a -> List.nth a 0) ulist in
    let unique_task_list = uniq task_list in
    let system_util = calculate_utilization unique_task_list ulist 0.0 in
    system_util

let utilization_analysis sys_util exp_util =
    (uprint_string (us "Utilization is "));(uprint_float sys_util);(uprint_endline (us ""));
    if (sys_util > exp_util) then ((uprint_endline (us "Utilization Cap Not Satisfiled")); exit 0)

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
            (*uprint_string (us "Misses \t"); uprint_string (us "Delta Min\t"); uprint_string (us "Delta Max \n")*)
             uprint_string (us "\nMisses \t"); uprint_string (us "WCET Margin\n")
        end in
    if (Array.length delta_min > i) then
        begin
            if ((delta_min.(i) <> delta_sup) & (delta_max.(i) <> 0.0)) then
                begin
                    (*uprint_int i; uprint_string (us "\t"); uprint_float delta_min.(i); uprint_string (us "\t"); uprint_float delta_max.(i); uprint_endline (us
                     * "")*)
                      uprint_int i; uprint_string (us "\t"); uprint_float delta_max.(i); uprint_endline (us "")
                end; print_delta_min_max delta_min delta_max delta_sup (i+1)
        end



let calculate_leeway l1 l2 =
    let lway = (float_of_string l1.dl) -. (float_of_string l2.wcct)   in
    let slack = if (lway < 0.0) then 0.0 else lway in
    let delta = ((float_of_string l1.cmax) +. slack) /. (float_of_string l1.cmax) in
    [l1.tskid; l2.jid; (string_of_float delta)]

let get_first_k_element lst n =
    let rec aux i acc = function
      | [] -> List.rev acc, []
      | h :: t as l -> if i = 0 then List.rev acc, l
                       else aux (i-1) (h :: acc) t  in
                       aux n [] lst;;


let calculate_leeway_new l1 l2 =
    let lway = (float_of_string l1.cmax) +. (Pervasives.max 0.0 ((float_of_string l1.dl) -. (float_of_string l2.wcct)))  in
    let delta = lway /. (float_of_string l1.cmax) in
    (delta)



let rec calculate_slack_each_task ip rta num_task i k dsup =
        if (i <= num_task) then
        begin
        (*let _ = uprint_string (us "calculate_misses_for_each_task : ") in
        let _ = uprint_int i; (uprint_string (us "\n")) in *)
            let ip_task = List.filter (fun a -> ((int_of_string a.tskid) = i)) ip in
            let rta_task = List.filter (fun a -> ((int_of_string a.tid) = i)) rta in
            let (ip_k, _) = get_first_k_element ip_task k in
            let (rta_k, _) = get_first_k_element rta_task k in
            let slack_list = List.map2 (calculate_leeway_new) ip_k rta_k in
            let slack_sort = List.sort (Pervasives.compare) slack_list in
            (*let _ = uprint_endline (us "here") in*)
            (*let  _ = List.iter (fun a -> uprint_float a) slack_sort in *)
            (*let _ = uprint_endline (us "here") in*)
            let indx = (List.length slack_sort) in
           (* let indx = if ((((List.length slack_sort) mod k) - 1) < 0) then 0 else (((List.length slack_sort) mod k) - 1) in*)
            (*let slack = List.fold_right Pervasives.max slack_list 0.0 in*)
            let slack = List.nth slack_sort (indx-1) in
            (*let _ = uprint_float slack in*)
            let new_dsup =  Pervasives.max dsup slack in
            calculate_slack_each_task ip rta num_task (i+1) k new_dsup
        end
        else
            dsup


let calculate_leeway_new lst =
    let lway = lst.icmax + lst.idl - lst.iwcct in
    let delta = (float_of_int lway) /. (float_of_int lst.icmax) in
    (delta)


let compare_sort a b =
    if (a.irmin = b.irmin) then 0 else
        (if (a.irmin > b.irmin) then 1 else 0)

let rec calculate_slack_each_task_updated lst num_task i k dsup =
        if (i <= num_task) then
        begin
        (*let _ = uprint_string (us "calculate_misses_for_each_task : ") in
        let _ = uprint_int i; (uprint_string (us "\n")) in *)
        let concat_task = List.filter (fun a -> ((int_of_string a.itskid) = i)) lst in
        let concat_sorted = List.sort (compare_sort) concat_task in
        let (concat_k, _) = get_first_k_element concat_sorted k in
        let slack_list = List.map (calculate_leeway_new) concat_k in
        let dsup_lst_max = List.fold_right Pervasives.max slack_list 0.0 in
        let new_dsup = Pervasives.max dsup dsup_lst_max in
        calculate_slack_each_task_updated lst num_task (i+1) k new_dsup
        end
        else
            dsup

let scale_input alpha =
    let inp = (read_data_input "input") in
    let actionlist =  (read_data_action "orginal_action") in
    let header = List.map (fun a -> [a.tskid; a.jobid; a.rmin; a.rmax; a.cmin;
    a.cmax; a.dl; a.priority]) ([List.hd inp]) in
    let noheader = List.tl inp in
    let original_csv =  List.map (fun a -> [a.tskid; a.jobid; a.rmin; a.rmax; a.cmin;
    a.cmax; a.dl; a.priority]) inp in
    let newip = List.map (fun a -> [a.tskid; a.jobid; a.rmin; a.rmax; a.cmin; (string_of_int (int_of_float ((alpha *. (float_of_string a.cmax))))); a.dl; a.priority]) noheader in
    let nip = List.append header newip in
    let act_header = List.map (fun a -> [a.atid; a.ajid; a.atmin; a.atmax; a.acmin; a.acmax]) ([List.hd actionlist]) in
    let act_noheader = List.tl actionlist in
    let act_newip = List.map (fun a -> [a.atid; a.ajid; a.atmin; a.atmax; a.acmin; (string_of_int (int_of_float ((alpha *. (float_of_string a.acmax)))))]) act_noheader in
    let act_nip = List.append act_header act_newip in
    let alpha_string = string_of_float alpha in
    Csv.save "action.csv" act_nip;
    Csv.save "job.csv" nip;
    Csv.save ((alpha_string)^"_job.csv") nip



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


let max_initial_upper_bound num_task k  =
    let ip = List.tl (read_data_input "job.csv") in
    let rta = List.tl (read_data_rta "job.rta.csv") in
    calculate_slack_each_task ip rta num_task 1 k 0.0

let max_initial_upper_bound_updated num_task k  =
    let ip = List.tl (read_data_input "job.csv") in
    let rta = List.tl (read_data_rta "job.rta.csv") in
    let concat_list_aux = List.map2 (fun a b -> (if ((a.tskid = b.tid) & (a.jobid = b.jid)) then [{itskid = a.tskid; ijobid = a.jobid; irmin = (int_of_string a.rmin); icmax = (int_of_string a.cmax); idl = (int_of_string a.dl); iwcct = (int_of_string b.wcct)}] else [])) ip rta in
    let concat_list = List.filter (function []-> false
                                        |_ -> true) concat_list_aux in
    let concat_list = List.map (function [a] -> a) concat_list in
    calculate_slack_each_task_updated concat_list num_task 1 k 0.0

    (*let (ip_k, ip_rest) = get_first_k_element ip k in
    let (rta_k, rta_rest) = get_first_k_element rta k in
    let lst = List.map2 (calculate_leeway_new) ip_k rta_k in
    let _ = Csv.save "check" lst in
    let t = List.map (function [ti; ji; lw] -> {ti; ji; lw}) lst in
    let minlw = List.fold_right Pervasives.max (List.map (fun a -> (float_of_string a.lw)) t) 0.0 in
    maxlw*)

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



let calculate_misses delta klist  =
    (*let _ = uprint_string (us "calculate_misses for "); uprint_float delta; uprint_endline (us "") in*)
    let _ = scale_input delta in
    (*let _ = uprint_endline (us "schedulability start\n") in*)
    (*let _ = if (ret_sim = 127) then exit 0 in*)
    let sim_csv = (string_of_float delta)^"_simulation.csv" in
    let ret = Sys.command "../timed-c-e2e-sched-analysis/scripts/simulate-pre-analysis.py --nptest ../timed-c-e2e-sched-analysis/build/nptest --jobs job.csv --action action.csv -t 180 -o  simulation.csv --num-random-releases 20 -- -p pred.csv -c" in
    let _ = Sys.command ("mv simulation.csv "^(sim_csv)) in
    let ret = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r job.csv -c -a action.csv -l 600 " in
    let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r job.csv -c -a action.csv -p pred.csv -l 300 " in
    (*let _ = if (ret == 127) then uprint_string (us "return"); exit 0 in*)
    let _ = sa_time := !sa_time + 1 in
    let _ = uprint_int (!sa_time); uprint_string (us ",") in
    (*let _ = uprint_endline (us "schedulability end\n") in*)
    let joblist =  create_mk_analysis_csv () in
    let num_task = List.length klist in
    let m = calculate_misses_for_each_task 1 num_task 0 klist joblist in
    (*uprint_string (us "number of misses :"); uprint_int m; uprint_endline (us "");*) m



let rec bsearch delta_min_lst delta_max_lst l u epsilon klist  =
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
    (*let _ = uprint_string (us "iter_bsearch :") in
    let _ = uprint_int i; uprint_endline (us "") in*)
    if (i < m ) then
        let u =  min_index delta_sup delta_min_lst m m (i+1) in
        (*let _ = uprint_float (delta_min_lst.(u)); uprint_endline (us "") in*)
        let (delta_min, delta_max, iprime) = bsearch delta_min_lst delta_max_lst i u epsilon klist in
        iter_bsearch delta_min delta_max delta_sup iprime m epsilon klist
    else
        (delta_min_lst, delta_max_lst)

let simulation_analysis_init sim_file delta =
    let _ = (uprint_float delta); (uprint_endline (us "simulation_analysis_int")) in
    let ip = List.tl (read_data_input "job.csv") in
    let rta = List.tl (read_data_rta sim_file) in
    let lst = List.map2 (fun a b -> if ((a.tid = b.tskid) & (a.jid = b.jobid)) then
                                        (Pervasives.abs_float((float_of_string b.dl) -. (float_of_string b.rmax))) /. (float_of_string a.wcct)
                                    else
                                        0.0 ) rta ip in
    let ext = List.exists (fun a -> (a > 50.00)) lst in
    if ext then
        (false)
    else
        true

let rec binary_simulation_search l u k num_task pdelta =
    let delta = (l +. u)/.2.0 in
    let _ = scale_input delta in
    let sim_csv = (string_of_float delta)^"_simulation.csv" in
    let ret = Sys.command "../timed-c-e2e-sched-analysis/scripts/simulate-pre-analysis.py --nptest ../timed-c-e2e-sched-analysis/build/nptest --jobs job.csv --action action.csv -t 180 -o  simulation.csv --num-random-releases 20 -- -p pred.csv -c" in
    let _ = Sys.command ("mv simulation.csv "^(sim_csv)) in
    let ip = List.tl (read_data_input "job.csv") in
    let rta = List.tl (read_data_rta sim_csv) in
    let lst = List.map2 (fun a b -> if ((a.tid = b.tskid) & (a.jid = b.jobid)) then
                                        [a.tid; a.jid; string_of_int ((int_of_string b.dl) - (int_of_string a.wcct))]
                                    else
                                        [] ) rta ip in
    let header = ["Task ID"; "Job ID"; "MISS"] in
    let mk_list = List.map (fun [tid; jid; misses] -> [(int_of_string tid); (int_of_string jid); (int_of_string misses)]) lst in
    let klist = Array.to_list (Array.make num_task k) in
    let m = calculate_misses_for_each_task 1 num_task 0 klist mk_list in
    let ldelta = if (m = (num_task *k)) then delta else pdelta in
    if (m < (num_task * k)) then
        (let cond = simulation_analysis_init ((string_of_float pdelta)^"_simulation.csv") pdelta in
        (*let _ = if (cond = false) then exit 0 in *)
        pdelta)
    else
        (binary_simulation_search l delta k num_task ldelta)


let rec calculate_delta_after_simulation original_delta delta fc k num_task =
    if (fc <= 0.0) then
        (*let _ = uprint_string (us "pre-simulation :"); uprint_float original_delta; uprint_string (us ":") ; uprint_float delta; uprint_endline (us "") in*)
        delta
    else
        (let fct = fc -. 0.1 in
         let new_delta = original_delta *. fct in
         let _ = scale_input new_delta in
         let sim_csv = (string_of_float new_delta)^"_simulation.csv" in
         let ret = Sys.command "../timed-c-e2e-sched-analysis/scripts/simulate-pre-analysis.py --nptest ../timed-c-e2e-sched-analysis/build/nptest --jobs job.csv --action action.csv -t 180 -o  simulation.csv --num-random-releases 20 -- -p pred.csv -c" in
         let _ = Sys.command ("mv simulation.csv "^(sim_csv)) in
         let cont = simulation_analysis_init sim_csv new_delta in
        if cont then
            (*let _ = uprint_string (us "pre-simulation :"); uprint_float original_delta; uprint_string (us ":") ; uprint_float delta; uprint_endline (us "") in *)
             new_delta
        else (calculate_delta_after_simulation original_delta (new_delta) fct k num_task ))


let sensitivity =
    let num_task = get_number_of_task () in
    (*let _ = uprint_int num_task; uprint_string (us "sensitivity\n") in*)
    let klist = Array.to_list ((Array.make num_task (int_of_string (Sys.argv.(1))))) in
    let epsilon_resolution = float_of_string (Sys.argv.(2)) in
    let exp_util = float_of_string (Sys.argv.(3)) in
    let sys_util = calculate_system_utilization () in
    (*let _ = utilization_analysis sys_util exp_util in
    let _ = uprint_string (us "utilization analysis complete") in *)
    let rets = Sys.command "../timed-c-e2e-sched-analysis/scripts/simulate-pre-analysis.py --nptest ../timed-c-e2e-sched-analysis/build/nptest --jobs job.csv --action action.csv -t 60 -o     simulation.csv --num-random-releases 20 -- -p pred.csv -c" in
    let sim_csv = "1.00_simulation.csv" in
    let _ = Sys.command ("mv simulation.csv "^(sim_csv)) in
    let ret = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r job.csv -c -a action.csv -p pred.csv -l 300 " in
    let _ = if (ret = 127) then exit 0 in
    let _ = uprint_int ret in
    let _ = sa_time := !sa_time + 1; uprint_string (us ",") in
    let _ = uprint_int (!sa_time) ; uprint_string (us ",") in
    let delta_sup = max_initial_upper_bound num_task (List.hd klist) in
    let delta_sup_updated = max_initial_upper_bound_updated num_task (List.hd klist) in
    let _ = uprint_string (us "delta_sup"); uprint_float delta_sup; uprint_string (us ":") ; uprint_float delta_sup_updated; uprint_endline (us "") in
    let delta_sup = Pervasives.max delta_sup 1.0 in
    let opt = Sys.argv.(4) in
    let delta_sup_cap =
    if (opt = "--sim") then
        (*let delta_sup_allowed = calculate_delta_after_simulation delta_sup delta_sup 1.0 (int_of_string (Sys.argv.(1))) num_task in*)
        (let delta_sup_allowed = binary_simulation_search 1.0 delta_sup (int_of_string (Sys.argv.(1)))  num_task delta_sup in
        let _ = uprint_string (us "pre-simulation :"); uprint_float delta_sup; uprint_string (us ":") ; uprint_float delta_sup_allowed; uprint_endline (us "") in
        delta_sup_allowed)
    else
        (if (opt = "--util") then
            (let delta_sup_allowed = exp_util/.sys_util in
            let _ = uprint_string (us "utilization-delta :"); uprint_float exp_util; uprint_string (us ":") ; uprint_float delta_sup_allowed; uprint_endline (us "") in
            delta_sup_allowed)
        else
            delta_sup) in
    let delta_sup = Pervasives.min delta_sup delta_sup_cap in
    let delta_inf = 0.0 in
    let epsilon = epsilon_resolution *. delta_sup in
    let m = calculate_misses delta_sup klist in
    let delta_min_lst = Array.make (m+1)delta_sup  in
    let delta_max_lst = Array.make (m+1) delta_inf in
    let _ = delta_min_lst.(0) <- delta_inf in
    let _ = delta_max_lst.(m) <- delta_sup in
    let (delta_min, delta_max) = iter_bsearch delta_min_lst delta_max_lst delta_sup 0 m epsilon klist in
    let _ = uprint_string (us "Utilization : "); uprint_float (epsilon); uprint_endline (us"") in
    let _ = uprint_string (us "Calculated epsilon : "); uprint_float (epsilon); uprint_endline (us"") in
    let _ = uprint_string (us "Total number of calls to sensitivity analysis : "); uprint_int (!sa_time); uprint_endline (us"") in
    print_delta_min_max delta_min delta_max delta_sup 0; ()








