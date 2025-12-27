(** Stemmer - Porter stemming algorithm implementation. *)

(** [stem word] reduces [word] to its root form using the Porter algorithm.
    Words with 2 or fewer characters are returned unchanged.

    Example: [stem "searching"] returns ["search"] *)
val stem : string -> string

(** [apply tokens] stems each token in the list, preserving positions. *)
val apply : (string * int) list -> (string * int) list
