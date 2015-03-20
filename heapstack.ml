open Astree;;

(* type declaration *)
type heaploc = Loc of int;;

type heapframe =
      NullFram
    | Value of int
    | Location of heaploc
    | Object of (field_node, heapframe) Hashtbl.t
    | Closure of var_node * cmd_node * (var_node, heaploc) Hashtbl.t
;;

(* global variable *)

let mainStack : (var_node, heaploc) Hashtbl.t  = Hashtbl.create 1024;;
let mainHeap  = Array.make 4096 NullFram;;
let heapCounter = ref 0;;

(* methods *)
let stack_add stack (var:var_node) (loc:heaploc) = 
    Hashtbl.add stack var loc 
;; 

let stack_clone stack =
    Hashtbl.copy stack
;;

let stack_find stack (var:var_node) = 
    Hashtbl.find stack var
;;


let heap_alloc () =
    let counter = !heapCounter in
        heapCounter := counter + 1;
        Loc(counter)
;;

let heap_size () =
    !heapCounter + 1
;;

let heap_set (loc:heaploc) (x:heapframe) =
    match loc with
    | Loc (pos) -> Array.set mainHeap pos x
;;

let heap_get (loc:heaploc) =
    match loc with
    | Loc (pos) -> Array.get mainHeap pos 
;;

let heap_add (x:heapframe) =
    let loc = heap_alloc () in 
        heap_set loc x
;;

(* constructor of heapframe*)


