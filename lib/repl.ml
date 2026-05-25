open Front

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
  | Keyword Create -> "Keyword: Create"
  | Keyword Select -> "Keyword: Select"
  | Keyword Insert -> "Keyword: Insert"
  | Keyword In -> "Keyword: In"
  | Keyword Left -> "Keyword: Left"
  | Keyword Right -> "Keyword: Right"
  | Keyword Inner -> "Keyword: Inner"
  | Keyword Outer -> "Keyword: Outer"
  | Keyword Join -> "Keyword: Join"
  | Keyword And -> "Keyword: And"
  | Keyword Or -> "Keyword: Or"
  | Keyword Where -> "Keyword: Where"
  | Identifier s -> "Identifier: " ^ s
  | Number n -> "Number: " ^ string_of_float n
  | String s -> "String: " ^ s
  | Equals -> "Equals"
  | LessThan -> "LessThan"
  | GreaterThan -> "GreaterThan"

let () = repl ()
