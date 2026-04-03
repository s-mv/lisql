(* AST *)

type number = float
type identifier = string
type value = Number of number | String of string
type typ = NumberType | StringType
type op = Gt | Lt | Eq
type predicate = op * identifier * value
type row = value list
type columns = identifier list
type column_def = identifier * typ
type schema = column_def list
type select = columns * identifier * predicate
type insert = identifier * row
type create = identifier * schema
type query = Select of select | Insert of insert | Create of create
type program = query

(* MIR *)
type plan =
  | Scan of identifier
  | Select of predicate * plan
  | Project of columns * plan

(* backend *)
(* TODO *)
