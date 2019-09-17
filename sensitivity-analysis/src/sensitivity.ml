open Printf
open Csv
open Ustring.Op
open Sys
open Array

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

type kcsv =
{
	ktskid : string;
	kwin : string;
	klim : string;
}

type mapcsv =
{
	mtskid : string;
	mindex : string;
}

let sa_time = ref 0

let read_data_ksv fname =
  Csv.load fname
  |> List.map (function [ktskid; kwin; klim] -> {ktskid; kwin; klim}
                      | _ -> failwith "read_data_output: incorrect file ksv")

let read_data_mapcsv fname =
  Csv.load fname
  |> List.map (function [mtskid; mindex] ->{mtskid; mindex}
                      | _ -> failwith "read_data_output: incorrect file mapcsv")



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

(*Description: Calculates system utilization*)
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

(*Description : Compares system utilization with utilization cap*)
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

    (*Description : Prints the WCET margins and M*)
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

(*let rec print_small_m delta_min delta_max delta_sup i slist =
    if (Array.length delta_min > i) then
        begin
            if ((delta_min.(i) <> delta_sup) & (delta_max.(i) <> 0.0)) then
                begin
                    let _ =  uprint_float delta_max.(i); uprint_endline (us "\n") in
                    let elem = List.find (fun a -> (fst a) = delta_max.(i) ) slist in
		    let _ = List.iter (fun a -> (uprint_int (fst a)); (uprint_int (snd a)); uprint_endline (us "")) (snd elem) in ()
                end; print_small_m  delta_min delta_max delta_sup (i+1) slist
        end *)

let rec print_sm delta_max slist tlist =
	let _ = uprint_endline (us "") in
	 match slist with
	 | ht :: rst -> if (List.exists (fun a -> a = (fst ht)) (Array.to_list delta_max))  then
				begin
					let _ = uprint_string (us "WCET Margin"); uprint_float (fst ht); uprint_endline (us "") in
					let _ = List.iter (fun a -> uprint_string (us (List.nth tlist ((fst a) - 1)^(":"))); (uprint_int (snd a)); uprint_endline (us "")) (snd ht)  in
					print_sm delta_max rst tlist
				end
			else
				 print_sm delta_max rst tlist
	 | [ht] -> let _ = uprint_string (us "WCET Margin"); uprint_float (delta_max.(0)); uprint_endline (us "") in
                       let _ = List.iter (fun a -> uprint_string (us (List.nth tlist ((fst a) - 1)^(":"))); (uprint_int (snd a)); uprint_endline (us "")) (snd ht)  in
			print_sm delta_max [] tlist
	 | [] -> ()

let print_small_m delta_min delta_max delta_sup i slist tlist =
    (*let _ = uprint_string (us "WCET Margin \t"); List.iter (uprint_string (us a)) tlist in*)
	 let _ = print_sm delta_max slist tlist in ()
	 (*let ht = List.hd (List.rev slist) in
         let _ = uprint_string (us "WCET Margin"); uprint_float (delta_max.(i-1)); uprint_endline (us "") in
         let _ = List.iter (fun a -> uprint_string (us (List.nth tlist ((fst a) - 1)^(":"))); (uprint_int (snd a)); uprint_endline (us "")) (snd ht)  in () *)

let rec print_sm_new delta_max slist tlist =
	 match slist with
	 | ht :: rst -> if (List.exists (fun a -> a = (fst ht)) (Array.to_list delta_max))  then
				begin
					let _ = uprint_float (fst ht); uprint_string (us "\t | ") in
                    let m = List.iter (fun a -> (uprint_string (us "\t"); uprint_int (snd a)); uprint_string (us  "\t")) (snd ht)  in
                    let _ = uprint_endline (us "") in
					print_sm_new delta_max rst tlist
				end
			else
				 print_sm_new delta_max rst tlist
	 | [ht] -> let _ = uprint_float (delta_max.(0)); uprint_string (us "\t") in
                       let _ = List.iter (fun a -> (uprint_int (snd a)); uprint_string (us "")) (snd ht)  in
			print_sm_new delta_max [] tlist
	 | [] -> ()

let rec print_small_m_new delta_min delta_max delta_sup i slist tlist =
    let _ = uprint_string (us "WCET Margin \t |"); List.iter (fun a -> ((uprint_string (us a)); ( uprint_string (us " | ")))) tlist in
    let _ = uprint_endline (us "") in
	 let _ = print_sm_new delta_max (List.rev slist) tlist in ()

(*let calculate_leeway l1 l2 =
    let lway = (float_of_string l1.dl) -. (float_of_string l2.wcct)   in
    let slack = if (lway < 0.0) then 0.0 else lway in
    let delta = ((float_of_string l1.cmax) +. slack) /. (float_of_string l1.cmax) in
    [l1.tskid; l2.jid; (string_of_float delta)]*)

let get_first_k_element lst n =
    let rec aux i acc = function
      | [] -> List.rev acc, []
      | h :: t as l -> if i = 0 then List.rev acc, l
                       else aux (i-1) (h :: acc) t  in
                       aux n [] lst;;



(*Description :Used for calculation of maximum initial upper bound as specified in older version of the algorithm in the paper
 * note: this is not called anymore and purely here for reference purposes
 * start*)

let calculate_leeway_two l1 l2 =
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
            let slack_list = List.map2 (calculate_leeway_two) ip_k rta_k in
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

let compare_sort a b =
    if (a.irmin = b.irmin) then 0 else
        (if (a.irmin > b.irmin) then 1 else 0)

let max_initial_upper_bound num_task k  =
    let ip = List.tl (read_data_input "job.csv") in
    let rta = List.tl (read_data_rta "job.rta.csv") in
    calculate_slack_each_task ip rta num_task 1 k 0.0

(*Description :Calculates maximum initial upper bound as specified in older version of the algorithm in the paper
 * note: this is not called anymore and purely here for reference purposes
 * end*)


(*Description: Function used to calculate slack that is used for calculation of maximum initial upper bound*)

let calculate_leeway_new lst =
    let lway = lst.icmax + lst.idl - lst.iwcct in
    let delta = (float_of_int lway) /. (float_of_int lst.icmax) in
    (delta)

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

(* Description : Scales the bcet of the original input and creates new job input for the schedulability analysis*)
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


(*Description: Creates a list for help calculate (m,k)*)
let create_mk_analysis_csv rta_file =
    let ip = List.tl (read_data_input "job.csv") in
    let rta = List.tl (read_data_rta rta_file) in
    let lst = List.map2 (fun a b -> if ((a.tid = b.tskid) & (a.jid = b.jobid)) then
                                        [a.tid; a.jid; string_of_int ((int_of_string b.dl) - (int_of_string a.wcct))]
                                    else
                                        [] ) rta ip in
    let header = ["Task ID"; "Job ID"; "MISS"] in
    let _ = Csv.save "job.mk" (header :: lst) in
    List.map (fun [tid; jid; misses] -> [(int_of_string tid); (int_of_string jid); (int_of_string misses)]) lst
   (* List.map2 (fun a b  -> [int_of_string a.tid; int_of_string a.jid; ((int_of_string b.dl) - (int_of_string a.wcct))]) rta ip*)




(*Description :Calculates maximum initial upper bound as specified in Algorithm 2 of the paper*)
let max_initial_upper_bound_updated num_task k  =
    let ip = List.tl (read_data_input "job.csv") in
    let rta = List.tl (read_data_rta "job.rta.csv") in
    let concat_list_aux = List.map2 (fun a b -> (if ((a.tskid = b.tid) & (a.jobid = b.jid)) then [{itskid = a.tskid; ijobid = a.jobid; irmin = (int_of_string a.rmin); icmax = (int_of_string a.cmax); idl = (int_of_string a.dl); iwcct = (int_of_string b.wcct)}] else [])) ip rta in
    let concat_list = List.filter (function []-> false
                                        |_ -> true) concat_list_aux in
    let concat_list = List.map (function [a] -> a) concat_list in
    calculate_slack_each_task_updated concat_list num_task 1 k 0.0


let findSchedulable ()  =
    let op = read_data_output "output" in
    let elem = List.hd op in
    (if (elem.is_schedulable = "1") then
        (uprint_endline ( us " : SCHEDULABLE"))
    else
        (uprint_endline (us " : NOT SCHEDULABLE")));
    elem.is_schedulable


let rec is_monotonic x =
  match x with
  | [] -> true
  | h::[] -> true
  | h::h2::t -> if h < h2 then is_monotonic (h2::t) else false


let rec k_window llst k i kwin len =
    (*let _ = uprint_string (us "k_window :") in
    let _ = uprint_int k; uprint_string (us " ");uprint_int i; uprint_string (us "\n") in
    let _ = uprint_int (i mod (len)) ;uprint_string (us "\n") in*)
    match k with
    |0 ->  kwin
    |_ ->  let l = (i mod (len)) in k_window llst (k-1) (i+1) ((List.nth llst l) :: kwin) len

(*Description: caculates number of misses in k consecutive windows for one tasks*)
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

(*Description : calculates number of misses in k consecutive execution of the tasks set*)
let rec calculate_misses_for_each_task i num_task m klist olst  smallm_list =
    if (i <= num_task) then
        (*let _ = uprint_string (us "calculate_misses_for_each_task : ") in
        let _ = uprint_int i; (uprint_string (us "\n")) in *)
        let llst = List.filter (fun a -> (List.hd a = i)) olst in
        let k = List.nth klist (i-1) in
        let mprime = calculate_misses_k llst k 0 0 (List.length llst) in
        let alist = (i, mprime) :: smallm_list in
        calculate_misses_for_each_task (i+1) num_task (m + mprime) klist olst alist
    else
        (m, smallm_list)


(*Description : Scales the original input, calls schedulability analysis, and calculates the number of misses in k windows*)
let calculate_misses delta klist num_task  =
    (*let _ = uprint_string (us "calculate_misses for "); uprint_float delta; uprint_endline (us "") in*)
    let _ = scale_input delta in
    (*let _ = uprint_endline (us "schedulability start\n") in*)
    (*let _ = if (ret_sim = 127) then exit 0 in*)
    (*let _ = if (ret == 127) then uprint_string (us "simulation timeout"); exit 0 in*)
    let ret = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r job.csv -c -a action.csv -p pred.csv -l 1800 " in
    (*let _ = if (ret == 127) then uprint_string (us "schedulability timeout"); exit 0 in*)
    let _ = sa_time := !sa_time + 1 in
    (*let _ = uprint_int (!sa_time); uprint_string (us ",") in
    let _ = uprint_endline (us "schedulability end\n") in*)
    let joblist =  create_mk_analysis_csv "job.rta.csv" in
    let num_task = List.length klist in
    let (m, slist) = calculate_misses_for_each_task 1 num_task 0 klist joblist [] in
    (*let _ = List.iter (fun a -> (uprint_int (fst a); uprint_int (snd a))) slist in*)
    let sprimelist = (delta, slist) in
    (*uprint_string (us "number of misses :"); uprint_int m; uprint_endline (us "");*) (m, sprimelist)


(*Description : Checks if the wcrt of any task in the output of the simulation tool is increasing monotonically*)
let rec simulation_analysis_each_task i num_task klist olst limit_of_interest =
    if (i <= num_task) then
        (*let _ = uprint_string (us "calculate_misses_for_each_task : ") in
        let _ = uprint_int i; (uprint_string (us "\n")) in *)
        let llst = List.filter (fun a -> (List.hd a = i)) olst in
        let k = List.nth klist (i-1) in
        let l = List.nth limit_of_interest (i -1) in
        let mprime = calculate_misses_k llst k 0 0 (List.length llst) in
	(*let _ = uprint_string (us "DEBUG - calculated m:"); uprint_string (us ":");  uprint_int mprime; uprint_endline (us "") in *)
        if (mprime > l) then true else (simulation_analysis_each_task (i+1) num_task klist olst limit_of_interest)
    else
        false


let rec simulation_binary_search low high num_task klist limit_of_interest epsilon =
    if ((high -. low) > epsilon) then (
        let value = (low +. high) /. 2.0 in
        let _ = scale_input value in
        let _ = Sys.command "../timed-c-e2e-sched-analysis/scripts/simulate-pre-analysis.py --nptest ../timed-c-e2e-sched-analysis/build/nptest --jobs job.csv --action action.csv -t 60 -o simulation.csv --num-random-releases 20 -- -p pred.csv -c" in
        let joblist =  create_mk_analysis_csv "simulation.csv" in
	let _ = uprint_string (us "DEBUG"); uprint_float value; uprint_endline (us "") in
        let ret = simulation_analysis_each_task 1 num_task klist joblist limit_of_interest in
        if (ret = true) then
            simulation_binary_search low value num_task klist limit_of_interest epsilon
        else
            simulation_binary_search value high num_task klist limit_of_interest epsilon)
    else
        low

let simulation_analysis_small_m sim_file num_task scale_factor klist limit_of_interest epsilon =
    let joblist =  create_mk_analysis_csv sim_file in
    let num_task = List.length klist in
    (*let _ = uprint_string (us "DEBUG"); uprint_float epsilon; uprint_string (us ":"); uprint_float scale_factor; uprint_endline (us "") in *)
    let ret = simulation_analysis_each_task 1 num_task klist joblist limit_of_interest in
    let (low, high) =  (0.0, scale_factor) in
    if ret then (simulation_binary_search low high num_task klist limit_of_interest epsilon) else scale_factor

let rec simulation_analysis_cap_M sim_file num_task klist =
    let joblist =  create_mk_analysis_csv sim_file in
    let num_task = List.length klist in
    let k = List.nth klist 0 in
    let (m, _) = calculate_misses_for_each_task 1 num_task 0 klist joblist [] in
    let limit = (num_task * k)/2 in
    (*let _ = uprint_string (us "DEBUG M - limit on M : calculated M"); (uprint_int limit); uprint_string (us ":");  uprint_int m; uprint_endline (us "") in
    *)if (m > limit) then ((uprint_endline (us "DISCARD"));true) else false

let simulation scale_factor num_task klist limit_of_interest epsilon =
            let _ = scale_input scale_factor in
            let rets = Sys.command "../timed-c-e2e-sched-analysis/scripts/simulate-pre-analysis.py --nptest ../timed-c-e2e-sched-analysis/build/nptest --jobs job.csv --action action.csv -t 60 -o simulation.csv --num-random-releases 100 -- -p pred.csv -c" in
            (*let _ = if (rets = 127) then uprint_string (us "simulation timeout"); exit 0 in*)
            (*let discardM = simulation_analysis_cap_M "simulation.csv" num_task klist in
            let _ = if (discardM = true) then exit 0 in *)
	    let delta = simulation_analysis_small_m "simulation.csv" num_task scale_factor klist limit_of_interest epsilon in
	    let _ = if (delta < epsilon) then ((uprint_endline (us "DISCARD"));exit 0) in
		delta

(* Description: Implements the bsearch algorithm (Algorithm 3 of the paper)*)

let rec bsearch delta_min_lst delta_max_lst l u epsilon klist num_task slist =
    (*let _ = uprint_string (us "bsearch") in
    let _ = uprint_int l; uprint_int u; uprint_endline (us "") in*)
    if (delta_min_lst.(u) -. delta_max_lst.(l) < epsilon) then
        (delta_min_lst, delta_max_lst, u, slist)
    else
        let delta_mid = (delta_min_lst.(u) +. delta_max_lst.(l)) /. 2.0 in
        let (m, stuple) = calculate_misses delta_mid klist num_task in
        let _ = delta_min_lst.(m) <- (Pervasives.min delta_min_lst.(m) delta_mid) in
        let _ = delta_max_lst.(m) <- (Pervasives.max delta_max_lst.(m) delta_mid) in
        let slistprime = stuple :: slist in
        let ub = if (l = m) then u else m in
        (*(uprint_string (us "ub"); uprint_int ub; uprint_endline (us ""));*)
        (bsearch delta_min_lst delta_max_lst l ub epsilon klist num_task slistprime)


let rec min_index delta_sup delta_min m cmin i =
    if (i < m) then
        if (delta_min.(i) < delta_sup) then
            min_index delta_sup delta_min m (Pervasives.min i m) (i+1)
        else
            min_index delta_sup delta_min m cmin (i+1)
    else
        (*(uprint_string (us "min_index"); uprint_int cmin; uprint_endline (us ""));*) cmin

(*Description : Calls bsearch for all valid deltas between delta_min and delta_max*)

let rec iter_bsearch delta_min_lst delta_max_lst delta_sup i m epsilon klist num_task slist =
    (*let _ = uprint_string (us "iter_bsearch :") in
    let _ = uprint_int i; uprint_endline (us "") in*)
    if (i < m ) then
        let u =  min_index delta_sup delta_min_lst m m (i+1) in
        (*let _ = uprint_float (delta_min_lst.(u)); uprint_endline (us "") in*)
    let (delta_min, delta_max, iprime, splist) = bsearch delta_min_lst delta_max_lst i u epsilon klist num_task slist in
        iter_bsearch delta_min delta_max delta_sup iprime m epsilon klist num_task splist
    else
        (delta_min_lst, delta_max_lst, slist)


let rec create_klist mlist klist i tid kint lint num_task =
    if (i <= num_task) then
        (*let _ = uprint_string (us "calculate_misses_for_each_task : ") in
        let _ = uprint_int i; (uprint_string (us "\n")) in *)
        let value = List.find (fun a -> (int_of_string a.mindex) = i) mlist in
        let kval = List.find (fun a -> a.ktskid = value.mtskid) klist in
	let (t, k, l) = (kval.ktskid, kval.kwin, kval.klim) in
	create_klist mlist klist (i+1) (t :: tid) (k :: kint) (l :: lint) num_task
    else
       (tid, kint, lint)

let create_interest_list num_tsk kname =
    let klist = List.tl (read_data_ksv kname) in
    let mlist = List.tl (read_data_mapcsv "map") in
    let (twin, kwin, lwin) = create_klist mlist klist 1 [] [] [] num_tsk in
    let kwin_int = List.map (fun a -> (int_of_string a)) kwin in
    let lwin_int = List.map (fun a -> (int_of_string a)) lwin in
     (List.rev twin, List.rev kwin_int, List.rev lwin_int)




(*Description : The main function for sensitivity analysis
 * Call simulation tool (simulate-pre-analysis.py) on input trace with timeout of 60 seconds
 * Call simulation_ana;ysis_init that analysis the out of the simulation tool
 * Call schedulability analysis (nptest) with timeout of 300 seconds
 * sa_time is a global counter that tracks the number of times schedulability analysis is called
 * Calculate delta_sup_org
 * Calculate delta_sup_util (if an utilization cap is specified)
 * Calculate epsilon using the epsilon resolution
 * Call iter_bsearch that inturn calls the bsearch algorithm*)

let sensitivity =
    let num_task = get_number_of_task () in
    (*let klist = Array.to_list ((Array.make num_task (int_of_string (Sys.argv.(1))))) in *)
    let kname = Sys.argv.(1) in
    let epsilon_resolution = float_of_string (Sys.argv.(2)) in
    let exp_util = float_of_string (Sys.argv.(3)) in
    (*let lname = Sys.argv.(4) in
    let limit_of_interest = Array.to_list ((Array.make num_task (int_of_string (Sys.argv.(4))))) in *)
    let (tlist, klist, limit_of_interest) = create_interest_list num_task kname in
    let sys_util = calculate_system_utilization () in
    let _ = uprint_string (us "Utilization : "); uprint_float (sys_util); uprint_endline (us"") in
    let delta_sup_cap = exp_util/.sys_util in
    let _ = uprint_string (us "Delta_sup_cap :"); uprint_float (delta_sup_cap); uprint_endline (us "") in
    let delta_sup_sim  = simulation delta_sup_cap num_task klist limit_of_interest (epsilon_resolution *. delta_sup_cap) in
    let _ = uprint_string (us "Delta_sup_sim :"); uprint_float (delta_sup_sim); uprint_endline (us "") in
    let delta_sup = (if ((sys_util < exp_util) & (delta_sup_cap > 1.0)) then
	 ( let ret = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r job.csv -c -a action.csv -p pred.csv -l 1800 " in
	  (*let _ = if (ret = 127) then exit 0 in*)
          (*let _ = (uprint_string (us "DEBUG : ")); (uprint_int ret) in*)
          let _ = sa_time := !sa_time + 1; uprint_string (us ",") in
          (*let delta_sup = max_initial_upper_bound num_task (List.hd klist) in*)
          let delta_sup_org =  max_initial_upper_bound_updated num_task (List.hd klist) in
          (*let _ = uprint_string (us "Delta_sup_org :"); uprint_float (delta_sup_org); uprint_endline (us "") in*)
           Pervasives.min delta_sup_org (Pervasives.min delta_sup_cap delta_sup_sim))
        (*let _ = uprint_string (us "DEBUG : delta_sup"); uprint_float delta_sup; uprint_string (us ":") ; uprint_float delta_sup_updated; uprint_endline (us
         * "") in *)
        else
           (Pervasives.min delta_sup_sim delta_sup_cap)) in
    let _ = uprint_string (us "Delta_sup :"); uprint_float (delta_sup); uprint_endline (us "") in
    let delta_inf = 0.0 in
    let epsilon = epsilon_resolution *. delta_sup in
    let (m, small) = calculate_misses delta_sup klist num_task in
    let delta_min_lst = Array.make (m+1)delta_sup  in
    let delta_max_lst = Array.make (m+1) delta_inf in
    let _ = delta_min_lst.(0) <- delta_inf in
    let _ = delta_max_lst.(m) <- delta_sup in
    let (delta_min, delta_max, slist) = iter_bsearch delta_min_lst delta_max_lst delta_sup 0 m epsilon klist num_task [] in
    let _ = uprint_string (us "Epsilon Resolution :"); uprint_float (epsilon_resolution); uprint_endline (us"") in
    let _ = uprint_string (us "Calculated epsilon : "); uprint_float (epsilon); uprint_endline (us "") in
    let _ = uprint_string (us "Total number of calls to sensitivity analysis : "); uprint_int (!sa_time); uprint_endline (us"") in
   (*print_delta_min_max delta_min delta_max delta_sup 0; print_small_m delta_min delta_max delta_sup (Array.length delta_max) (small::slist) tlist;*)
    uprint_endline (us "\n*************************************************\nThe number of deadline misses (m) for each task\n**************************************************");
    print_small_m_new delta_min delta_max delta_sup (Array.length delta_max) (small::slist) tlist; uprint_string (us
    "\n***************************************\nSummary of weakly-hard constraint (M)\n***************************************");
print_delta_min_max delta_min delta_max delta_sup 0;()






