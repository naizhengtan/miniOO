(* type declaration *)

type var_node =
    Variable of string

and field_node = 
    Field of string

and decl_node = 
    Decl of var_node 

and procedure =
    Procedure of (*string * function name*)
                 var_node * (*parameter*)
                 cmd_node (* code *) 

and expr_node =
      FieldExpr of field_node
    | VarExpr of var_node
    | ProcExpr of procedure
    | Number of int
    | Minus of expr_node * expr_node
    | Plus of  expr_node * expr_node
    | Deref of expr_node * expr_node
    | Null of unit

and bool_node =
      True 
    | False 
    | Equal of expr_node * expr_node
    | Lt  of expr_node * expr_node 
    | Gt  of expr_node * expr_node

and cmd_node =
      Skip
    | VarDel of decl_node * cmd_node
    | ProcCall of expr_node * expr_node
    | Malloc of expr_node
    | VarAssign of var_node * expr_node
    | FieldAssign of expr_node * field_node * expr_node
    | Scope of cmd_node * cmd_node
    | Loop of bool_node * cmd_node
    | Cond of bool_node * cmd_node * cmd_node
    | Parl of cmd_node * cmd_node
    | Atom of cmd_node
;;
(* Print functions *)

let print_field x =
    match x with
    | Field (var) -> print_string ("Field:("^var^")")
;;

let print_var x =
    match x with
    | Variable (var) -> print_string ("Var:("^var^")")
;;

let print_decl x = 
    match x with
    | Decl (vname) -> 
            print_string "Define(";
            print_var vname;
            print_string ")"
;;

let rec print_proc x =
    match x with
    | Procedure (param, code) -> 
            print_string "Func: {";
            print_var param;
            print_cmd code;
            print_string "}"

and print_expr x =
    match x with
    | FieldExpr (field) -> print_field field
    | VarExpr (var) -> print_var var
    | Number (v) -> print_int v
    | Minus (expr1, expr2) -> 
            print_string "(";
            print_expr expr1; 
            print_string " - "; 
            print_expr expr2;
            print_string ")"
    | Plus  (expr1, expr2) -> 
            print_string "(";
            print_expr expr1; 
            print_string " + "; 
            print_expr expr2;
            print_string ")"
    | ProcExpr (proc) -> print_proc proc
    | Deref (expr1, expr2) -> 
            print_string "(";
            print_expr expr1;
            print_string ".";
            print_expr expr2;
            print_string ")"
    | Null (null) -> print_string "null" 

and print_bool x =
    match x with
      True -> print_string "true"
    | False -> print_string "false" 
    | Equal (expr1, expr2) ->
            print_string "(";
            print_expr expr1;
            print_string " == ";
            print_expr expr2;
            print_string ")"
    | Lt (expr1, expr2) ->
            print_string "(";
            print_expr expr1;
            print_string " < ";
            print_expr expr2;
            print_string ")"
    | Gt  (expr1, expr2) ->
            print_string "(";
            print_expr expr1;
            print_string " > ";
            print_expr expr2;
            print_string ")"

and print_cmd x =
    match x with
    | Skip -> print_string "skip"
    | VarDel (decl, cmd) -> 
            print_decl decl;
            print_string ";";
            print_cmd  cmd
    | ProcCall (expr1, expr2) ->
            print_string "func[";
            print_expr expr1;
            print_string "](";
            print_expr expr2;
            print_string ")"
    | Malloc (expr) -> 
            print_string "malloc(";
            print_expr expr;
            print_string ")"
    | VarAssign (var, expr) ->
            print_string "(";
            print_var var;
            print_string "=";
            print_expr expr;
            print_string ")"
    | FieldAssign (expr1, field, expr2) ->
            print_string "(";
            print_expr expr1;
            print_string ".";
            print_field field;
            print_string "=";
            print_expr expr2;
            print_string ")"
    | Scope (cmd1, cmd2) ->
            print_string "{";
            print_cmd cmd1;
            print_string ";";
            print_cmd cmd2;
            print_string "}"
    | Loop (boolean, cmd) ->
            print_string "while(";
            print_bool boolean;
            print_string "{";
            print_cmd cmd;
            print_string "}"
    | Cond (boolean, cmd1, cmd2) ->
            print_string "if(";
            print_bool boolean;
            print_string ") then {";
            print_cmd cmd1;
            print_string "} else {";
            print_cmd cmd2;
            print_string "}"
    | Parl (cmd1, cmd2) ->
            print_string "parallel{";
            print_cmd cmd1;
            print_string "}{";
            print_cmd cmd2;
            print_string "}"
    | Atom (cmd) ->
            print_string "Atomic(";
            print_cmd cmd;
            print_string ")"
;;

let rec print_prog = function 
    | [] -> print_newline ()
    | cmd::prog -> print_cmd cmd;
                   print_string ";";
                   print_prog prog
;;
