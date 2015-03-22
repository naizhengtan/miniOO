open Astree;;

(* configuration *)
let hEAP_SIZE = 4096 * 4096;;
let sTACK_SIZE = 4096;;
let sTACK_DEPTH = 1024;;
let oBJ_SIZE = 4096;;

(* type declaration *)
type heaploc = Loc of int;;

type heapframe =
      NullFram
    | Empty
    | Value of int
    | FieldIndex of field_node 
    | Object of (string, heapframe) Hashtbl.t
    | Closure of var_node * cmd_node * (string, heaploc) Hashtbl.t
;;

(* global variable *)

let mainStack : (string, heaploc) Hashtbl.t  = Hashtbl.create sTACK_SIZE;;
let stackHistory = Array.make sTACK_DEPTH mainStack;;
let curStack = ref mainStack;;
let stackHistoryPos = ref 0;;

let mainHeap = ref (Array.make hEAP_SIZE NullFram);;
let heapCounter = ref 0;;

(* methods *)

let stack_history_push (stack: (string, heaploc) Hashtbl.t) =
    stackHistoryPos := !stackHistoryPos + 1;
    let newstack = Hashtbl.copy stack in
        Array.set stackHistory !stackHistoryPos newstack 
;;

let stack_history_pop () =
    let pos = !stackHistoryPos in
        stackHistoryPos := !stackHistoryPos - 1;
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
        heapCounter := !heapCounter + 1;
        Loc(counter)
;;

let heap_size () =
    !heapCounter + 1
;;

let heap_set (loc:heaploc) (x:heapframe) =
    match loc with
    | Loc (pos) -> Array.set !mainHeap pos x
;;

let heap_get (loc:heaploc) =
    match loc with
    | Loc (pos) -> Array.get !mainHeap pos 
;;

let heap_add (x:heapframe) =
    let loc = heap_alloc () in 
        heap_set loc x
;;

let obj_add (hobj:heapframe) (fname:string) (v:heapframe) =
    match hobj with 
    | Object (obj) -> 
       if Hashtbl.mem obj fname then
           Hashtbl.replace obj fname v
       else 
           Hashtbl.add obj fname v
    | _ -> print_string "Error 6: only object can use field.\n"
;;

let obj_find (hobj:heapframe) (fname:string) =
    match hobj with 
    | Object(obj) ->
       if Hashtbl.mem obj fname then
           Hashtbl.find obj fname
       else
           NullFram
    | _ -> print_string "Error 6: only object can use field.\n";NullFram
;;

(* constructor of heapframe*)

let gen_empty_obj () =
    let empty = Hashtbl.create oBJ_SIZE in
        Object (empty)
;;

(* garbage collection *)

let add_to_map map (index:string) (loc:heaploc) =
    match loc with 
    | Loc (hloc) -> 
        if not (Hashtbl.mem map hloc) then
            Hashtbl.add map hloc (Hashtbl.length map)
;;

let trace_stack_var mapTbl stack =
    Hashtbl.iter (add_to_map mapTbl) stack 
;;

let fill_heap_frame newHeap (oldLoc:int) (newLoc:int) =
    let frame = (Array.get !mainHeap oldLoc) in
        Array.set newHeap newLoc frame
;;

let gen_new_heap mapTbl newHeap =
    Hashtbl.iter (fill_heap_frame newHeap) mapTbl
;;

let fix_to_map map stack (index:string) (loc:heaploc) =
    match loc with 
    | Loc (hloc) -> 
        if not (Hashtbl.mem map hloc) then 
            (print_string "FATAL error: gc failed!\n";
            exit(1)
            )
        else
            Hashtbl.replace stack index (Loc(Hashtbl.find map hloc))
;;

let fix_stack_var mapTbl stack =
    Hashtbl.iter (fix_to_map mapTbl stack) stack 
;;

let gc () =
    let newHeap = Array.make hEAP_SIZE NullFram in
    let mapTbl = Hashtbl.create hEAP_SIZE in
    begin
        (* 1. create mapping table *)
        for stacknum = 0 to !stackHistoryPos do
            trace_stack_var mapTbl (Array.get stackHistory stacknum)
        done;
        (* 2. generate new heap *)
        gen_new_heap mapTbl newHeap;
        (* 3. fix stack references *)
        for stacknum = 0 to !stackHistoryPos do
            fix_stack_var mapTbl (Array.get stackHistory stacknum)
        done;
        (* 4. change heap *)
        mainHeap := newHeap;
        heapCounter := Hashtbl.length mapTbl
    end
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
    | Empty -> print_string "";
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
