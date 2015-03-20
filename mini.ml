open Parsing;;
open Astree;;
open Heapstack;;
open Executor;;

let lexbuf = Lexing.from_channel stdin in
try
    let ast = MiniYACC.prog MiniLEX.token lexbuf in
    print_prog ast;
    exec ast;
    print_stack ();
    print_heap ()
with Parse_error ->
    let curr = lexbuf.Lexing.lex_curr_p in
    let line = curr.Lexing.pos_lnum in
    let cnum = curr.Lexing.pos_cnum - curr.Lexing.pos_bol in
    let tok = Lexing.lexeme lexbuf in
    (print_string "Syntax error ... line: "; 
    print_int line;
    print_string " num: ";
    print_int cnum;
    print_string (" token: "^tok^"\n"));
    clear_parser ()
;;

