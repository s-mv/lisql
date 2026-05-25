(* AST *)

type number = float
type identifier = string

(* values *)
type value = Number of number | String of string

(* types for columns *)
type typ = NumberType | StringType

(* operators *)
type op = GreaterThan | LessThan | EqualTo

(* predicates *)
type predicate =
  | Compare of op * identifier * value
  | And of predicate list
  | Or of predicate list

(* rows and columns *)
type row = value list
type columns = identifier list

(* schema definitions *)
type column_def = identifier * typ
type schema = column_def list

(* joins *)
type join_type = Inner | Left | Right | Outer
type join_clause = join_type * identifier * predicate option

(* queries *)
type select = columns * identifier * join_clause list * predicate option
type insert = identifier * row
(* table * row *)

type create = identifier * schema
(* table * schema *)

type query = Select of select | Insert of insert | Create of create

(* top-level program *)
type program = query list

(* MIR *)
type plan =
  | Scan of identifier
  | Select of predicate * plan
  | Project of columns * plan
  | Join of join_type * plan * plan * predicate

(* backend *)
(* TODO *)
