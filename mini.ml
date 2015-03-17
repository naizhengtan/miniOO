open Parsing;;
open Astree;;

let rec print_ast = function 
    | [] -> ()
    | cmd::prog -> print_cmd cmd; print_ast prog
;;

try
    let lexbuf = Lexing.from_channel stdin in
    while true do
        try
            let ast = MiniYACC.prog MiniLEX.token lexbuf in
                print_ast ast 
        with Parse_error ->
            (print_string "Syntax error ..."; print_newline ());
            clear_parser ()
    done
with MiniLEX.Eof ->
    ()
;;
