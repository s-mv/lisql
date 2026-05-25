open Types

(* lexer specific *)

type keyword =
  | Create
  | Select
  | In
  | Insert
  | Left
  | Right
  | Inner
  | Outer
  | Join
  | And
  | Or
  | Where

type token =
  | LParen
  | RParen
  | Equals
  | LessThan
  | GreaterThan
  | Keyword of keyword
    (* for now we just support integers even if number is float *)
  | Number of number
  | String of string
  | Identifier of string

type index = int
type line = int
type column = int
type position = line * column * index
type source = string
type lexer = source * position

(* lexer related functions *)

let peek ((src, (_, _, index)) : lexer) : char option =
  if index >= String.length src then None else Some src.[index]

let advance ((src, (line, column, index)) as lexer : lexer) : lexer =
  match peek lexer with
  | Some '\n' -> (src, (line + 1, 1, index + 1))
  | Some _ -> (src, (line, column + 1, index + 1))
  | None -> lexer

let next ((src, (line, column, index)) as lexer : lexer) : lexer =
  match peek lexer with
  | Some '\n' -> (src, (line + 1, 1, index + 1))
  | Some _ -> (src, (line, column + 1, index + 1))
  | None -> lexer

let rec skip_whitespace (lexer : lexer) : lexer =
  match peek lexer with
  | Some (' ' | '\t' | '\n') -> skip_whitespace (advance lexer)
  | _ -> lexer

let lex_number (lexer : lexer) : (lexer * token) option =
  let rec consume lex acc =
    match peek lex with
    | Some n when '0' <= n && n <= '9' ->
        consume (advance lex) (acc ^ String.make 1 n)
    | _ -> (lex, acc)
  in
  let lexer', number = consume lexer "" in
  Some (lexer', Number (float_of_string number))

let lex_keyword_or_identifier (lexer : lexer) : (lexer * token) option =
  let rec consume lex acc =
    match peek lex with
    | Some c when ('A' <= c && c <= 'Z') || ('a' <= c && c <= 'z') ->
        consume (advance lex) (acc ^ String.make 1 c)
    | _ -> (lex, acc)
  in
  let lexer', word = consume lexer "" in
  match String.lowercase_ascii word with
  | "create" -> Some (lexer', Keyword Create)
  | "select" -> Some (lexer', Keyword Select)
  | "in" -> Some (lexer', Keyword In)
  | "insert" -> Some (lexer', Keyword Insert)
  | "left" -> Some (lexer', Keyword Left)
  | "right" -> Some (lexer', Keyword Right)
  | "inner" -> Some (lexer', Keyword Inner)
  | "outer" -> Some (lexer', Keyword Outer)
  | "join" -> Some (lexer', Keyword Join)
  | "and" -> Some (lexer', Keyword And)
  | "or" -> Some (lexer', Keyword Or)
  | "where" -> Some (lexer', Keyword Where)
  | _ -> Some (lexer', Identifier word)

let lex_string (lexer : lexer) : (lexer * token) option =
  match peek lexer with
  | Some delim ->
      let lexer = advance lexer in
      let rec consume l acc =
        match peek l with
        | Some c when c = delim -> (advance l, acc)
        | Some c -> consume (advance l) (acc ^ String.make 1 c)
        | None -> failwith "Unterminated string literal"
      in
      let lexer', str = consume lexer "" in
      Some (lexer', String str)
  | None -> None

let lex_one (lexer : lexer) : (lexer * token) option =
  let lexer = skip_whitespace lexer in
  match peek lexer with
  | None -> None
  | Some '(' -> Some (advance lexer, LParen)
  | Some ')' -> Some (advance lexer, RParen)
  | Some '=' -> Some (advance lexer, Equals)
  | Some '<' -> Some (advance lexer, LessThan)
  | Some '>' -> Some (advance lexer, GreaterThan)
  | Some c when '0' <= c && c <= '9' -> lex_number lexer
  | Some c when ('A' <= c && c <= 'Z') || ('a' <= c && c <= 'z') ->
      lex_keyword_or_identifier lexer
  | Some '"' -> lex_string lexer
  | Some other -> failwith ("Unexpected characer: " ^ String.make 1 other)

(* just a helper *)
let rec lex_all lexer =
  match lex_one lexer with
  | None -> []
  | Some (lexer', tok) -> tok :: lex_all lexer'

(* parser stuff *)

let peek_token (lexer : lexer) : token option =
  match lex_one lexer with Some (_, token) -> Some token | None -> None

let next_token (lexer : lexer) : lexer * token =
  match lex_one lexer with
  | Some (lexer', token) -> (lexer', token)
  | None -> failwith "Parsing error!"

let expect (token : token) (lexer : lexer) =
  match lex_one lexer with
  | Some (lexer', tok) when tok = token -> lexer'
  | _ -> failwith "Parsing error!"

(* let parse (src : source) : option program = () *)
