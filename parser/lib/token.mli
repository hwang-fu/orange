(** Token - Token types for query DSL. *)

type t =
  | AND
  | OR
  | NOT
  | LPAREN
  | RPAREN
  | QUOTE
  | WORD of string
  | EOF

(** [to_string token] returns a string representation for debugging. *)
val to_string : t -> string
