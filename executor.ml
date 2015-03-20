open Heapstack;;
open Astree;;

let rec eval (expr: expr_node) =
    match expr with 
    | VarExpr(var) -> 
            let loc = stack_find !curStack var in
                heap_get loc
    | ProcExpr(proc) -> 
        (match proc with
        | Procedure (var, cmd) ->
            Closure (var, cmd, Hashtbl.copy !curStack)
        )
    | Number(num) -> Value(num) 
    | Plus (expr1, expr2) ->
            let val1 = eval expr1 in
            let val2 = eval expr2 in
                (match val1 with
                | Value(num1) ->
                        (match val2 with 
                        | Value(num2) ->
                                Value (num1 + num2)
                        | _ -> print_string "Error 1: 
                                only num can applied for +\n"; NullFram
                        )
                | _ -> print_string "Error 1: only num can 
                                    applied for +\n"; NullFram
                )
    | Minus (expr1, expr2) ->
            let val1 = eval expr1 in
            let val2 = eval expr2 in
                (match val1 with
                | Value(num1) ->
                        (match val2 with 
                        | Value(num2) ->
                                Value (num1 - num2)
                        | _ -> print_string "Error 3: 
                                only num can applied for -\n"; NullFram
                        )
                | _ -> print_string "Error 3: only num can 
                                    applied for -\n"; NullFram
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
                | _ -> print_string "Error 2: proc is not funct!\n")
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
