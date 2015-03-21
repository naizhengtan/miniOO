open Heapstack;;
open Astree;;

let glock = Mutex.create ();;

let rec compare_equal (v1:heapframe) (v2:heapframe) = 
    match v1 with 
    | Value (num1) -> (match v2 with 
                      | Value(num2) -> if num1 = num2 then true else false  
                      | _ -> false )
    | NullFram  -> (match v2 with 
                      | NullFram -> true 
                      | _ -> false )
    | FieldIndex (_) -> false (* does this make any sense? *)
    | Closure (_,_,_) -> false
    | Object (obj1) -> (match v2 with 
                       | Object(obj2) -> compare_obj obj1 obj2
                       | _ -> false )

and compare_obj obj1 obj2 = 
    let equal = ref true in
        Hashtbl.iter (gen_compare_func equal obj2) obj1;
        Hashtbl.iter (gen_compare_func equal obj1) obj2;
        !equal

and gen_compare_func equal obj index value =
    if Hashtbl.mem obj index then
        let cont = (Hashtbl.find obj index) in
            if not (compare_equal value cont) then
                equal := false

let rec eval_bool (cond: bool_node) =
    match cond with
    | True -> true 
    | False -> false
    | Equal (expr1, expr2) ->
            let val1 = eval expr1 in
            let val2 = eval expr2 in
                compare_equal val1 val2
    | Lt (expr1, expr2) ->
            let val1 = eval expr1 in
            let val2 = eval expr2 in
                (match val1 with
                | Value(v1) -> 
                        (match val2 with 
                        | Value(v2) -> if v1 < v2 then true else false 
                        | _ -> print_string "Error 4, Only number allows
                                    to compare using <\n"; false
                        )
                | _ -> print_string "Error 4, Only number allows
                                    to compare using <\n"; false
                )
    | Gt (expr1, expr2) ->
            let val1 = eval expr1 in
            let val2 = eval expr2 in
                (match val1 with
                | Value(v1) -> 
                        (match val2 with 
                        | Value(v2) -> if v1 > v2 then true else false 
                        | _ -> print_string "Error 5, Only number allows
                                    to compare using >\n"; false
                        )
                | _ -> print_string "Error 5, Only number allows
                                    to compare using >\n"; false
                )


and eval (expr: expr_node) =
    match expr with 
    | FieldExpr(field) -> FieldIndex(field)
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
    | Deref (expr1, expr2) ->
            let obj = eval expr1 in
            let field = eval expr2 in
                (match field with
                | FieldIndex(f) -> obj_find obj f
                | _ -> print_string "Error 7: only field is allowed in
                            deref expresion\n"; NullFram;
                )
    | Null (_) -> NullFram

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
                        (* stack will be copied inside*)
                        stack_history_push !curStack; 
                        curStack := Hashtbl.copy !curStack;
                        (let loc = heap_alloc () in
                            stack_add !curStack var loc;
                            heap_set loc arg;
                            exec_cmd cmd);
                        let oldStack = stack_history_pop () in
                            curStack := oldStack
                | _ -> print_string "Error 2: proc is not funct!\n")
    | Malloc (var) -> 
            let loc = heap_alloc () in
                stack_add !curStack var loc;
                heap_set loc (gen_empty_obj ())
    | VarAssign (var, expr) ->
            let loc = stack_find !curStack var in
                let value = eval expr in
                    heap_set loc value 
    | FieldAssign (expr1, field, expr2) ->
            let obj = eval expr1 in
            let value = eval expr2 in
                obj_add obj field value
    | Scope (cmdlist) ->
            stack_history_push !curStack;
            curStack := Hashtbl.copy !curStack;
            exec cmdlist;
            let oldStack = stack_history_pop () in
                curStack := oldStack
    | Loop (cond, cmd) -> 
            let condv = ref (eval_bool cond) in 
                while !condv do
                    exec_cmd cmd;
                    condv := (eval_bool cond)
                done
    | Cond (cond, cmd1, cmd2) ->
            if eval_bool cond then
                exec_cmd cmd1
            else 
                exec_cmd cmd2
    | Parl (cmd1, cmd2) ->
            let tid = Thread.create exec_cmd cmd1 in
                exec_cmd cmd2;
                Thread.join tid
    | Lock (cmd) -> 
            Mutex.lock glock;
            exec_cmd cmd;
            Mutex.unlock glock

and exec (prog: cmd_node list) =
    match prog with 
    | [] -> ()
    | cmd::prog -> exec_cmd cmd; exec prog
;;
