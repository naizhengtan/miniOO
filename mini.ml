open Parsing;;
try
    let lexbuf = Lexing.from_channel stdin in
    while true do
        try
            MiniYACC.cmd MiniLEX.token lexbuf
        with Parse_error ->
            (print_string "Syntax error ..."; print_newline ());
            clear_parser ()
    done
with MiniLEX.Eof ->
    ()
;;
