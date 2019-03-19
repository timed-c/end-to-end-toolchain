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

type mk_analysis =
{
    task_id : string;
    job_id : string;
    completion_time : string;
    deadline : string;
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

let read_data_mk fname =
  Csv.load fname
  |> List.map (function [task_id; job_id; completion_time; deadline; miss] ->
          {task_id; job_id; completion_time; deadline; miss}
                      | _ -> failwith "read_data_mk: incorrect file input")

let read_data_rta fname =
  Csv.load fname
  |> List.map (function [tid; jid; bcct; wcct; bcrt; wcrt] ->
          {tid; jid; bcct; wcct; bcrt; wcrt}
                      | _ -> failwith "read_data_rta: incorrect file rta")

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
    (*let _ = uprint_endline (us "Orginal CSV") in*)
    let original_csv =  List.map (fun a -> [a.tskid; a.jobid; a.rmin; a.rmax; a.cmin;
    a.cmax; a.dl; a.priority]) inp in
    (*let _ = Csv.print original_csv in *)
    let newip = List.map (fun a -> [a.tskid; a.jobid; a.rmin; a.rmax; a.cmin;
    (string_of_int (int_of_float ((alpha *. (float_of_string a.cmax))))); a.dl; a.priority]) noheader in
    let nip = List.append header newip in
    (*let _ = uprint_endline (us "Scaled CSV") in
    let _ = Csv.print nip in *)
    Csv.save "job.csv" nip

let create_mk_analysis_csv () =
    let ip = List.tl (read_data_input "job.csv") in
    let rta = List.tl (read_data_rta "job.rta.csv") in
    (*let _ = uprint_string (us "create_mk_analysis") in*)
    let lst = List.map2 (fun a b -> if ((a.tid = b.tskid) & (a.jid = b.jobid))
    then (if ((int_of_string a.wcct) < (int_of_string b.dl)) then [a.tid; a.jid; a.wcct; b.dl; "0"] else
        [a.tid; a.jid; a.wcct; b.dl; "1"]) else []) rta ip in
    let header = ["Task ID"; "Job ID"; "WCCT"; "DEADLINE"; "MISS"] in
    let _ = Csv.save "job.mk" (header :: lst) in
    (*let _ = uprint_string (us "create_mk_analysis - end") in*)
    ()

let rec add_to_tuple_lst tl taskid value final_list  =
    match tl with
    | h :: rst when ((int_of_string (fst h)) = taskid) -> let newh = ( (fst h),
    (List.append (snd h) [value])) in add_to_tuple_lst rst taskid value (newh ::
        final_list)
    | h :: rst  when (((int_of_string (fst h))) <> taskid)  -> add_to_tuple_lst
    rst taskid value (h :: final_list)
    | [] -> final_list

let rec create_list_from_mk_string_list csv tuple_list =
    match csv with
    | h :: rst -> let tuple_list_imm = if (List.exists (fun a -> if
        (((int_of_string (fst a))) = (int_of_string h.task_id)) then true else
            false) tuple_list) then (add_to_tuple_lst tuple_list (int_of_string
            h.task_id) h.miss []) else ((h.task_id, [h.miss]) :: tuple_list) in
                    create_list_from_mk_string_list rst tuple_list_imm
    | [] -> tuple_list

let initial_high () =
    let ip = List.tl (read_data_input "job.csv") in
    let rta = List.tl (read_data_rta "job.rta.csv") in
    let _ =  create_mk_analysis_csv () in
    let lst = List.map2 (calculate_leeway) ip rta in
    let _ = Csv.save "check" lst in
    let t = List.map (function [ti; ji; lw] -> {ti; ji; lw}) lst in
    let minlw = List.fold_right min (List.map (fun a -> a.lw) t)
    1000000000000.0 in
    if (minlw <= 1.0) then 1.0 else minlw

let findSchedulable ()  =
    let op = read_data_output "output" in
    let elem = List.hd op in
    (*if (elem.is_schedulable = "1") then (uprint_endline ( (us (elem.file) )^.(us
    ":") ^.( us "SCHEDULABLE"))) else
        (uprint_endline ((us elem.file)^. (us ":")^.(us "NOT
         SCHEDULABLE"))); elem.is_schedulable *)
       if (elem.is_schedulable = "1") then (uprint_endline ( us " : SCHEDULABLE")) else
        (uprint_endline (us " : NOT SCHEDULABLE")); elem.is_schedulable


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
        (*let _ = uprint_endline (ustring_of_float low) in
        let _ = uprint_endline (ustring_of_float high) in *)
        let _ = uprint_string (ustring_of_float value) in
        let _ = scale_input value in
        let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r -c job.csv > output" in
        let is = findSchedulable () in
        if (is = "0") then
            binary_search low value
        else
            binary_search value high)
    else (
        let _ = uprint_string (us "Maximum scaling factor is : ") in
        let _ = uprint_float low in
        let _ = uprint_endline (us "") in
        low )

let create_list_from_mk_csv () =
    let lst_from_file = List.tl (read_data_mk "job.mk") in
    (*let lst_from_file_int = List.map (function a -> ({(int_of_string a.task_id);
    (int_of_string a.job_id); (int_of_string a.completion_time); (int_of_string
    a.deadline); (int_of_string a.miss)})) lst_from_file in *)
    let lst_for_analysis = create_list_from_mk_string_list lst_from_file [] in
    (*let _ = List.iter (fun a -> (uprint_string ((us (fst a)) ^. (us "-->"))); (List.iter (fun b->
        (uprint_string ((us b) ^. (us ",")))) (snd a)); uprint_endline (us " "))
        lst_for_analysis in *)
    lst_for_analysis


let rec fold_until_slice f acc n = function
    | [] -> (acc, [])
    | h :: t as l -> if n = 0 then (acc, l)
                     else fold_until_slice f (f acc h) (n-1) t

let slice lst i k =
    let _, lst = fold_until_slice (fun _ _ -> []) [] i lst in
    let taken, _ = fold_until_slice (fun acc h -> h :: acc) [] (k - i + 1) lst in
    List.rev taken

let calculate_n_for_k lst cmisses =
    let mlst = List.find_all (fun a -> if (a=1) then true else false) lst in
    let nmisses = List.length mlst in
    if (nmisses > cmisses) then nmisses else cmisses

let rec call_calculate_n_for_k lst len k cindex cmisses =
    match cindex with
    | t when t >= len -> cmisses
    | _ -> let new_lst = slice lst cindex (cindex + k) in
           let misses = calculate_n_for_k new_lst cmisses in
           call_calculate_n_for_k lst len k (cindex + 1) misses

let rec create_repeating_list_for_nk olst nlst rlen k =
    let len_nlst = List.length nlst in
    match len_nlst with
    |t when t >= rlen-> nlst
    |_ -> let split_list = slice olst 0 k in
           create_repeating_list_for_nk olst (List.append nlst split_list) rlen k

let rec compute_mk_each_task original_list k =
    match original_list with
    | (tid, tlist):: rst  -> let len = List.length tlist in
                      let lst = create_repeating_list_for_nk tlist [] (len + (k - 1)) k in
                      let lst_int = List.map (fun a -> int_of_string a) lst in
                      let n = call_calculate_n_for_k lst_int len (k - 1) 0 0 in
                      let _ = uprint_string ((us "task id :") ^. (us tid) ^. (us
                      " n :")); uprint_int (n); uprint_string (us " k :");
                      uprint_int k; uprint_endline (us " ") in
                      compute_mk_each_task rst k
    | [] -> ( )


let findSchedulable_mk ()  =
    let op = read_data_output "output" in
    let elem = List.hd op in
    elem.is_schedulable

let rec mk_binary_search low high k =
    if ((high -. low) > 0.05) then (
        let value = (low +. high) /. 2.0 in
        (*let _ = uprint_endline (ustring_of_float low) in
        let _ = uprint_endline (ustring_of_float high) in *)
        let _ = uprint_string ((us "Scaling Factor :") ^. (ustring_of_float
        value)); uprint_endline (us " ") in
        let _ = scale_input value in
        let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r -c  job.csv > output" in
        let is = findSchedulable_mk () in
        let _ =  create_mk_analysis_csv () in
        let mlst = create_list_from_mk_csv () in
        let _ = compute_mk_each_task mlst k in
        let _ = mk_binary_search low value k in
        let _ = mk_binary_search value high k in ()
     )


let sensitivity =
    let high = initial_high () in
    let low = 1.0 in
    let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r -c job.csv > output" in
    let _ = uprint_string (us "1") in
    let is = findSchedulable () in
    let _ = uprint_string (ustring_of_float high) in
    let _ = scale_input high in
    let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r -c job.csv > output" in
    let ist = findSchedulable () in
    let alpha  = if (is = "1") then (binary_search low high) else 1.0 in
    let _ = (uprint_string ((us "Range of Scaling factor for (n, k) analysis: [") ^. (ustring_of_float (alpha)) ^.
    (us ", ") ^. (ustring_of_float high) ^. (us "]"))) in
    let _ = uprint_endline (us "") in
    let _ = uprint_string (us "(n, k) analysis") in
    let _ = uprint_endline (us "") in
    let k = if ((Array.length Sys.argv - 1) = 0) then 3 else (int_of_string
    Sys.argv.(1)) in
    let _ = mk_binary_search alpha high k in
()

(*

let sensitivity =
    let high = initial_high () in
    let low = 1.0 in
    let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r -c job.csv > output" in
    let _ = uprint_string (us "1") in
    let is = findSchedulable () in
    let _ = uprint_string (ustring_of_float high) in
    let _ = scale_input high in
    let _ = Sys.command "../timed-c-e2e-sched-analysis/build/nptest -r -c job.csv > output" in
    let is = findSchedulable () in
    let alpha  = if (is = "1") then (binary_search low high) else 1.0 in
    (*let _ = uprint_string (us "Maximum scaling factor is :"); uprint_float alpha;
    uprint_endline (us "") in*)
    let _ = uprint_endline (us "(n,k) analysis") in
    let _ = (uprint_string ((us "Range : [") ^. (ustring_of_float (alpha +. 0.05)) ^.
    (us ", ") ^. (ustring_of_float high) ^. (us "]"))); uprint_endline (us "") in
   (* let _ = print_string "Enter the value of k: " in
    let k = read_int () in*)
    let k = if ((Array.length Sys.argv - 1) = 0) then 3 else (int_of_string
    Sys.argv.(1)) in
    let _ = mk_binary_search alpha high k in
    ()
    *)


(*
let chck_n_k =
    let lst = [0;1;0;1;0;1;1;1] in
    let k = 3 in
    let len = List.length lst in
    let nlst = create_repeating_list lst [] (len + (k -1 )) k in
    let _ = List.iter  (fun a -> uprint_int a) nlst in
    let n = call_calculate_n_for_k nlst len k 0 0 in
    uprint_string (us "n k:"); uprint_int n
*)



