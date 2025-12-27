(* ast.ml - Abstract Syntax Tree for query DSL *)

type expr =
  | Term of string (* single word: search *)
  | Phrase of string list (* quoted phrase: "search engine" *)
  | And of expr * expr (* expr AND expr *)
  | Or of expr * expr (* expr OR expr *)
  | Not of expr (* NOT expr *)

(* Convert AST to string for debugging *)
let rec to_string = function
  | Term w -> Printf.sprintf "Term(%s)" w
  | Phrase words -> Printf.sprintf "Phrase(%s)" (String.concat " " words)
  | And (l, r) -> Printf.sprintf "And(%s, %s)" (to_string l) (to_string r)
  | Or (l, r) -> Printf.sprintf "Or(%s, %s)" (to_string l) (to_string r)
  | Not e -> Printf.sprintf "Not(%s)" (to_string e)
;;

(* Convert AST to JSON string *)
let rec to_json = function
  | Term w -> Printf.sprintf {|{"type": "term", "value": "%s"}|} w
  | Phrase words ->
    Printf.sprintf {|{"type": "phrase", "value": "%s"}|} (String.concat " " words)
  | And (l, r) ->
    Printf.sprintf {|{"type": "and", "left": %s, "right": %s}|} (to_json l) (to_json r)
  | Or (l, r) ->
    Printf.sprintf {|{"type": "or", "left": %s, "right": %s}|} (to_json l) (to_json r)
  | Not e -> Printf.sprintf {|{"type": "not", "expr": %s}|} (to_json e)
;;
