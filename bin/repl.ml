open Front

let rec lex_all lexer =
  match lex_one lexer with
  | None -> []
  | Some (lexer', tok) -> tok :: lex_all lexer'

let rec repl () =
  print_string "> ";
  flush stdout;
  match read_line () with
  | exception End_of_file ->
      print_endline "\nBye!";
      ()
  | line ->
      let lexer : lexer = (line, (1, 1, 0)) in
      let tokens = lex_all lexer in
      List.iter (fun tok -> Printf.printf "%s\n" (token_to_string tok)) tokens;
      repl ()

and token_to_string = function
  | LParen -> "LParen"
  | RParen -> "RParen"
  | Symbol Create -> "Symbol: Create"
  | Symbol Select -> "Symbol: Select"
  | Symbol Insert -> "Symbol: Insert"
  | Identifier s -> "Identifier: " ^ s
  | Number n -> "Number: " ^ string_of_float n
  | String s -> "String: " ^ s

let () = repl ()

