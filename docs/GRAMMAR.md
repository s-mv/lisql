# lisql grammar

TODO elaborate.

``` ebnf
<program> ::= <query>+

<query> ::= <create>
          | <insert>
          | <select>

<create> ::= '(' "create" <identifier> <schema> ')'
<schema> ::= '(' <column_def>* ')'
<column_def> ::= '(' <identifier> <type> ')'
<type> ::= "int" | "string"

<insert> ::= '(' "insert" <identifier> <row> ')'
<row> ::= '(' <value>* ')'
<value> ::= <number> | <string>
<number> ::= <digit>+
<string> ::= '"' ... '"'

<select> ::= '(' "select" <columns> <table_ref> <join_clause>* <where_clause>? ')'
<columns> ::= '(' <identifier>* ')'
<table_ref> ::= <identifier>

<join_clause> ::= '(' <join_type> "join" <table_ref> "on" <predicate> ')'
<join_type> ::= "inner" | "left" | "right" | "outer"

<where_clause> ::= '(' "where" <predicate_expr> ')'
<predicate_expr> ::= <predicate>
                   | '(' "and" <predicate_expr>+ ')'
                   | '(' "or" <predicate_expr>+ ')'

<predicate> ::= '(' <op> <identifier> <value> ')'
<op> ::= '>' | '<' | '='

<identifier> ::= <letter> (<letter> | <digit>)*
<letter> ::= 'A'..'Z' | 'a'..'z'
<digit> ::= '0'..'9'
```
