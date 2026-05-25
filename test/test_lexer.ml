open OUnit2
open Lisql.Front

let lex src = lex_all (src, (1, 1, 0))

let test_select_keyword _ =
  let tokens = lex "select" in
  let expected = [ Keyword Select ] in
  assert_equal expected tokens

let test_simple_query _ =
  let tokens = lex "select age in users" in
  let expected =
    [ Keyword Select; Identifier "age"; Keyword In; Identifier "users" ]
  in
  assert_equal expected tokens

let test_numbers _ =
  let tokens = lex "69 420" in
  let expected = [ Number 69.0; Number 420.0 ] in
  assert_equal expected tokens

let suite =
  "lexer_tests"
  >::: [
         "select keyword" >:: test_select_keyword;
         "simple query" >:: test_simple_query;
         "numbers" >:: test_numbers;
       ]

let () = run_test_tt_main suite
