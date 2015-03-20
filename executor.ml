open Heapstack;;
open Astree;;

let rec eval (expr: expr_node) =
    match expr with 
    | VarExpr(var) -> 
            let loc = stack_find !curStack var in
                heap_get loc
    | Number(num) -> Value(num) 
    | ProcExpr(proc) -> 
        (match proc with
        | Procedure (var, cmd) ->
            Closure (var, cmd, Hashtbl.copy !curStack)
        )
    | _ -> print_string "unfinished expr eval\n"; NullFram

let rec exec_cmd (cmd: cmd_node) =
    match cmd with
    | Skip -> ()
    | VarDel (Decl(var), subcmd) ->
            let loc = heap_alloc () in 
                stack_add !curStack var loc;
                exec_cmd subcmd
    | ProcCall (expr1, expr2) ->
            let func = eval expr1 in
            let arg = eval expr2 in
                (match func with 
                | Closure(var, cmd, stack) ->
                        stack_history_push !curStack;
                        curStack := Hashtbl.copy stack;
                        (let loc = heap_alloc () in
                            stack_add !curStack var loc;
                            heap_set loc arg;
                            exec_cmd cmd);
                        let oldStack = stack_history_pop () in
                            curStack := oldStack
                | _ -> print_string "proc is not funct!\n")
    | VarAssign (var, expr) ->
            let loc = stack_find !curStack var in
                let value = eval expr in
                    heap_set loc value 
    | _ -> print_string "unfinished cmd execution\n"
;;

let rec exec (prog: cmd_node list) =
    match prog with 
    | [] -> ()
    | cmd::prog -> exec_cmd cmd; exec prog
;;
