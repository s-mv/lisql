# Examples

This document demonstrates example LisQL queries and their corresponding ASTs in
the fully typed functional style. As you can see, this is simply a lisp. Which
is lovely.

## 1. CREATE TABLE

    (create users
      (
        (id int)
        (name string)
        (age int)
      )
    )

**AST Representation**

    Create (
      "users",
      [
        ("id", NumberType);
        ("name", StringType);
        ("age", NumberType)
      ]
    )

--------------------------------------------------------------------------------

## 2. INSERT ROW

    (insert users (1 "Alice" 25))

**AST Representation**

    Insert (
      "users",
      [
        Number 1.;
        String "Alice";
        Number 25.
      ]
    )

--------------------------------------------------------------------------------

## 3. SIMPLE SELECT

    (select (id name age) users)

**AST Representation**

    Select (
      ["id"; "name"; "age"],   (* columns *)
      "users",                 (* table *)
      [],                      (* no joins *)
      None                     (* no WHERE *)
    )

--------------------------------------------------------------------------------

## 4. SELECT WITH WHERE

    (select (id name) users
      (where (> age 18))
    )

**AST Representation**

    Select (
      ["id"; "name"],
      "users",
      [],
      Some (Compare (Gt, "age", Number 18.))
    )

--------------------------------------------------------------------------------

## 5. SELECT WITH NESTED WHERE (AND / OR)

    (select (id name) users
      (where (and
                (> age 18)
                (< age 65)
             )
      )
    )

**AST Representation**

    Select (
      ["id"; "name"],
      "users",
      [],
      Some (
        And [
          Compare (Gt, "age", Number 18.);
          Compare (Lt, "age", Number 65.)
        ]
      )
    )

--------------------------------------------------------------------------------

## 6. SELECT WITH A JOIN

    (select (id name) users
      (left join orders on (= user_id 1))
      (where (> age 18))
    )

**AST Representation**

    Select (
      ["id"; "name"],
      "users",
      [
        (Left, "orders", Some (Compare (Eq, "user_id", Number 1.)))
      ],
      Some (Compare (Gt, "age", Number 18.))
    )

--------------------------------------------------------------------------------

## 7. SELECT WITH NATURAL JOIN (no ON predicate)

    (select (id name) users
      (inner join orders)
    )

**AST Representation**

    Select (
      ["id"; "name"],
      "users",
      [
        (Inner, "orders", None)  (* natural join *)
      ],
      None
    )

--------------------------------------------------------------------------------

## 8. COMPLEX SELECT WITH MULTIPLE JOINS

    (select (id name) users
      (left join orders on (= user_id 1))
      (inner join payments)
      (where (or
                (> age 18)
                (< age 65)
             )
      )
    )

**AST Representation**

    Select (
      ["id"; "name"],
      "users",
      [
        (Left, "orders", Some (Compare (Eq, "user_id", Number 1.)));
        (Inner, "payments", None)
      ],
      Some (
        Or [
          Compare (Gt, "age", Number 18.);
          Compare (Lt, "age", Number 65.)
        ]
      )
    )
