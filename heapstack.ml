open Astree;;

(* type declaration *)
type heaploc = Loc of int;;

type heapframe =
      NullFram
    | Value of int
    | FieldIndex of field_node 
    | Object of (string, heapframe) Hashtbl.t
    | Closure of var_node * cmd_node * (string, heaploc) Hashtbl.t
;;

(* global variable *)

let mainStack : (string, heaploc) Hashtbl.t  = Hashtbl.create 1024;;
let stackHistory = Array.make 1024 mainStack;;
let curStack = ref mainStack;;
let stack_history_pos = ref 0;;

let mainHeap  = Array.make 4096 NullFram;;
let heapCounter = ref 0;;

(* methods *)

let stack_history_push (stack: (string, heaploc) Hashtbl.t) =
    stack_history_pos := !stack_history_pos + 1;
    let newstack = Hashtbl.copy stack in
        Array.set stackHistory !stack_history_pos newstack 
;;

let stack_history_pop () =
    let pos = !stack_history_pos in
        stack_history_pos := !stack_history_pos - 1;
        Array.get stackHistory pos
;;

let stack_add stack (var:var_node) (loc:heaploc) = 
    match var with
    | Variable(vname) -> 
            if Hashtbl.mem stack vname then
                Hashtbl.replace stack vname loc
            else 
                Hashtbl.add stack vname loc 
;; 

let stack_clone stack =
    Hashtbl.copy stack
;;

let stack_find stack (var:var_node) = 
    match var with
    | Variable(vname) -> Hashtbl.find stack vname 
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

let obj_add (hobj:heapframe) (f:field_node) (v:heapframe) =
    match hobj with 
    | Object (obj) -> 
        begin
        match f with
        | Field(fname) ->
            if Hashtbl.mem obj fname then
                Hashtbl.replace obj fname v
            else 
                Hashtbl.add obj fname v
        end
    | _ -> print_string "Error 6: only object can use field.\n"
;;

let obj_find (hobj:heapframe) (f:field_node) =
    match hobj with 
    | Object(obj) ->
        (match f with 
        | Field(fname) ->
            if Hashtbl.mem obj fname then
                Hashtbl.find obj fname
            else
                NullFram
        )
    | _ -> print_string "Error 6: only object can use field.\n";NullFram
;;

(* constructor of heapframe*)

let gen_empty_obj () =
    let empty = Hashtbl.create 128 in
        Object (empty)
;;

(* print stack, print heap *)
let print_stackframe (index:string) (loc:heaploc) =
    print_string (index^" -> ");
    match loc with 
    | Loc(pos) -> print_int pos
    ;
    print_string "\n"
;;

let print_stack () =
    print_string "-----Stack-----\n";
    Hashtbl.iter print_stackframe mainStack;
    print_string "---------------\n"
;;

let rec print_obj (ht: (string, heapframe) Hashtbl.t) =
    Hashtbl.iter print_field_heapframe ht

and print_field_heapframe (f:string) (h:heapframe) =
    print_string ("["^f^": ");
    print_heapframe h;
    print_string "]"

and print_heapframe (frame:heapframe) =
    match frame with
    | NullFram -> print_string "Null";
    | Value(num) -> print_int num;
    | FieldIndex(_) -> print_string "FieldIndex";
    | Object(obj) -> 
            print_string "Object: ";
            print_obj obj
    | Closure(var, cmd, _) -> 
            print_string "Closure: "; 
            print_var var;
            print_cmd cmd
                        
;;

let print_heap () =
    let counter = ref 0 in 
        print_string "------Heap (size:";
        print_int !heapCounter;
        print_string ")------\n";
        while !counter < !heapCounter do 
            print_int !counter;
            print_string ":  ";
            print_heapframe (heap_get (Loc(!counter)));
            print_string "\n";
            counter := !counter + 1
        done;
        print_string "---------------\n"
;;
