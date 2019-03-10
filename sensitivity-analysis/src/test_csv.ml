open Csv
open Printf
open Ustring.Op
open Yojson.Safe

exception Eson of string

type person_info =
{
  src : string;
  arrival  : string;
  release : string;
  jitter : string;
  execution : string;
  dst : string;
}
let read_data fname =
  Csv.load fname
  |> List.map (function [src; arrival; release; jitter; execution; dst] -> {src;
  arrival; release; jitter; execution; dst}
                      | _ -> failwith "read_data: incorrect file")

let filter_edges s d t =
    List.filter (fun a -> (a.src = s) && (a.dst = d) ) t

let max a b  =
    let aint = int_of_string a in
    if (aint > b) then aint else b

let min a b =
    let aint = int_of_string a in
    if (aint < b) then aint else b

let print tname src dst =
    if (tname = "usqrt") then
    (let t = read_data tname in
    let noheader = List.tl t in
    let edge_list = filter_edges (string_of_int src) (string_of_int dst) noheader in
    let maxjitter = List.fold_right max (List.map (fun a -> a.jitter) edge_list)
    0 in
    let maxexe = List.fold_right max (List.map (fun a -> a.execution) edge_list)
    0 in
    let minexe = List.fold_right min (List.map (fun a -> a.execution) edge_list)
    1000000000000 in
    uprint_endline ((ustring_of_int maxjitter)^.(us ",")^.(ustring_of_int
    maxexe)^.(us ",")^.(ustring_of_int minexe)))


let src_of_edge e =
    match (List.nth e 0) with
    |`Assoc[(sl)] -> (match (sl) with
                    |(_,`Int(s)) -> s
                    |_ -> raise (Eson "not src node"))

let dst_of_edge e =
    match (List.nth e 1) with
    |`Assoc[(sl)] -> (match (sl) with
                    |(_,`Int(s)) -> s
                    |_ -> raise (Eson "not src node"))

(*let bcet_of_edge e =
    List.nth e 2

let wcet_of_edge e =
    List.nth e 3
*)

let edgesjson elem =
    match elem with
    |`Assoc[(_, elist)] -> (match elist with
                          |`List(edgelist) -> edgelist
                          |_ -> raise (Eson "not an edge list"))
    |_ -> raise (Eson "not edge list")

let nodesjson velist =
    match velist with
    |`Assoc(_, nlist) -> (match nlist with
                          |`List(nodelist)-> nodelist
                          |_-> raise (Eson "not a node lsit"))
    |_ -> raise (Eson "not vertices list")

let task_flow_graph elem =
    match (List.hd elem) with
    |`Assoc[(velist)] -> velist
    |_ -> raise (Eson "not task flow graph")

let rec find_tfg_values tname elist =
    match elist with
    | [] -> ()
    | (`Assoc(edge)) :: rest -> let src = src_of_edge edge in
                              let dst = dst_of_edge edge in
                              let _ = print tname src dst in
                              find_tfg_values tname rest
    |_ -> raise (Eson "not edge edge")

let rec generate_tfg taskset =
    match taskset with
    |h :: rest -> let (eilist, vilist) = (match h with
                              |`Assoc[(vn, ve); (en, ee)] -> (ve, ee)
                              |_ -> raise (Eson "not assoc")) in
                  (*let velist = task_flow_graph elem in *)
                  let elist = edgesjson eilist in
                  let vlist = edgesjson vilist in
                  let _ = find_tfg_values "nnn" elist in
                  (*generate_tfg rest*) ()
    |[] -> ()



let read_taskset_from_tfgminus =
    let jtfg = Yojson.Safe.from_file "tfg_minus.json" in
    let taskset = (match jtfg with
                   |(`List(taskset)) -> taskset
                   | _ -> raise (Eson "json is not a task list")) in
    generate_tfg taskset





