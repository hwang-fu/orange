(** Lexer - Tokenizer for query DSL. *)

(** The lexer state. *)
type t

(** [create input] creates a new lexer from input string. *)
val create : string -> t

(** [next_token lexer] returns the next token and advances the lexer. *)
val next_token : t -> Token.t
