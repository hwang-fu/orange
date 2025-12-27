(** Tokenizer - Splits raw text into tokens with positions. *)

(** [tokenize text] splits [text] on whitespace, lowercases each word,
    and returns a list of (token, position) pairs.

    Example: [tokenize "Hello World"] returns [("hello", 0); ("world", 1)] *)
val tokenize : string -> (string * int) list
