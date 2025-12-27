(** Pipeline - Orchestrates the text processing stages. *)

(** [process text] runs the full text processing pipeline:
    tokenize -> filter stopwords -> stem.

    Returns a list of (stemmed_token, original_position) pairs. *)
val process : string -> (string * int) list
