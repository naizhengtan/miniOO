open Heapstack;;
open Astree;;

let rec eval (expr: expr_node) =
    match expr with 
    | Number(num) -> Value(num) 
    | _ -> print_string "unfinished expr eval"; NullFram

let rec exec_cmd (cmd: cmd_node) =
    match cmd with
    | VarDel (Decl(var), subcmd) ->
            let loc = heap_alloc () in 
                stack_add !curStack var loc;
                exec_cmd subcmd
    | VarAssign (var, expr) ->
            let loc = stack_find !curStack var in
                let value = eval expr in
                    heap_set loc value 
    | _ -> print_string "unfinished cmd execution"
;;

let rec exec (prog: cmd_node list) =
    match prog with 
    | [] -> ()
    | cmd::prog -> exec_cmd cmd; exec prog
;;
