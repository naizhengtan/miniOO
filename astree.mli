(* type declaration *)

type var_node =
    Variable of string

and field_node = 
    Field of string

and decl_node = 
    Decl of string

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
and prog_node =
    Prog of cmd_node list
;;

