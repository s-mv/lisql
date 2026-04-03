# lisql - lisp-like SQL on steroids

Or so I like to say.

## What is lisql?

lisql is a simple lisp-like functional querying language. TODO populate this
README.

## Build and run

Simply run `dune exec lisql` to use it. TODO populate this too... Eh.

## Example syntax

    (create users ((name string) (age int)))

    (insert users ("smv" 22))
    (insert users ("bertholdt" 18))

    (select (name age) users (> age 20))

