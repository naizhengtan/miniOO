{
    open MiniYACC;;
    exception Eof;;
}

let var = '$'(['a' - 'z']|['A' - 'Z']|['0' - '9'])+
let field = (['a' - 'z']|['A' - 'Z'])(['a' - 'z']|['A' - 'Z']|['0' - '9'])*
let num = ['0' - '9']+

rule token = parse
  | [' ' '\t' '\n'] { token lexbuf } 
  | "var"        { DEFINE }
  | '+'          { PLUS }
  | '-'          { MINUS }
  | '='          { ASSIGN }
  | "=="         { EQUAL }
  | '('          { PARENOPEN }
  | ')'          { PARENCLOSE }
  | '{'          { SOPEN }
  | '}'          { SCLOSE }
  | '.'          { DOT }
  | ':'          { COLON }
  | ';'          { SEMICOLON }
  | '<'          { LESSTHAN }
  | '>'          { GREATTHAN }
  | "|||"        { PARELLEL }
  | "null"       { NULL }
  | "proc"       { PROC }
  | "true"       { TRUE }
  | "false"      { FALSE }
  | "atomic"     { ATOMIC }
  | "malloc"     { MALLOC }
  | "if"         { IF }
  | "else"       { ELSE }
  | "while"      { WHILE }
  | "skip"       { SKIP }
  | var as v     { VAR v }
  | field as f   { FIELD f }
  | num as n     { NUM (int_of_string n) }
  | eof          { EOF }
(*
and test = parse
  | [' ' '\t' '\n'] { test lexbuf } 
  | "var"        { print_string "VAR "; test lexbuf}
  | var as v     { print_string ("var("^v^") "); test lexbuf}
  | field as f   { print_string ("field("^f^") "); test lexbuf}
  | num as n     { print_string ("num("^n^") "); test lexbuf} 
  | '+'          { print_string "PLUS ";test lexbuf}
  | '-'          { print_string "MINUS ";test lexbuf}
  | '='          { print_string "ASSIGN ";test lexbuf}
  | "=="         { print_string "EQUAL ";test lexbuf }
  | '('          { print_string "PARENOPEN ";test lexbuf}
  | ')'          { print_string "PARENCLOSE ";test lexbuf}
  | '{'          { print_string "SOPEN ";test lexbuf}
  | '}'          { print_string "SCLOSE ";test lexbuf}
  | '.'          { print_string "DOT ";test lexbuf}
  | ':'          { print_string "COLON ";test lexbuf}
  | ';'          { print_string "SEMICOLON ";test lexbuf}
  | '<'          { print_string "LESSTHAN";test lexbuf}
  | '>'          { print_string "GREATTHAN";test lexbuf}
  | "|||"        { print_string "PARELLEL ";test lexbuf}
  | "null"       { print_string "NULL ";test lexbuf}
  | "proc"       { print_string "PROC ";test lexbuf}
  | "true"       { print_string "TRUE ";test lexbuf}
  | "false"      { print_string "FALSE ";test lexbuf}
  | "atomic"     { print_string "ATOMIC ";test lexbuf}
  | "malloc"     { print_string "MALLOC ";test lexbuf}
  | "if"         { print_string "IF ";test lexbuf}
  | "else"       { print_string "ELSE ";test lexbuf}
  | "while"      { print_string "WHILE ";test lexbuf}
  | "skip"       { print_string "SKIP ";test lexbuf}
  | eof          { raise Eof}

{
let main () = 
    let lexbuf = Lexing.from_channel stdin in
        print_string "start parsing\n";
        test lexbuf

let _ = Printexc.print main ()
}
*)
