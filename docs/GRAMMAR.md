# lisql grammar

TODO elaborate.

``` ebnf
<program> ::= <query>

<query> ::= <create>
          | <insert>
          | <select>

<create> ::= (create <identifier> <schema>)

<insert> ::= (insert <identifier> <row>)

<select> ::= (select <columns> <identifier> <predicate>?)

<schema> ::= ( <column_def>* )

<column_def> ::= (<identifier> <type>)

<columns> ::= ( <identifier>* )

<row> ::= ( <value>* )

<predicate> ::= (<op> <identifier> <value>)

<op> ::= > | < | =

<type> ::= int | string

<value> ::= <number> | <string>

<identifier> ::= <letter> (<letter> | <digit>)*

<number> ::= <digit>+

<string> ::= "..."
```
