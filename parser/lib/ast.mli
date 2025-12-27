(** Ast - Abstract Syntax Tree for query DSL. *)

type expr =
  | Term of string
  | Phrase of string list
  | And of expr * expr
  | Or of expr * expr
  | Not of expr

(** [to_string expr] returns a debug string representation. *)
val to_string : expr -> string

(** [to_json expr] returns JSON representation for IPC with indexer. *)
val to_json : expr -> string
