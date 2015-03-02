{
    open MiniYACC;;
    exception Eof;;
}

let var = '$'(['a' - 'z']|['A' - 'Z']|['0' - '9'])+
let field = (['a' - 'z']|['A' - 'Z']|['0' - '9'])+
let num = ['0' - '9']+

rule token = parse
  | [' ' '\t' '\n'] { token lexbuf } 
  | "var"        { DEFINE }
  | var as v     { VAR v}
  | num as n     { NUM (int_of_string n) } 
  | ';'          { SEMICOLON }
  | '-'          { MINUS }
  | '='          { ASSIGN }
  | '{'          { SOPEN }
  | '}'          { SCLOSE}
  | eof          { raise Eof}

{
let main () = 
    let lexbuf = Lexing.from_channel stdin in
        token lexbuf

let _ = Printexc.print main ()
}

