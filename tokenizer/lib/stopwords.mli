(** Stopwords - Common English stopwords filtering. *)

(** [is_stopword word] returns [true] if [word] is a common stopword. *)
val is_stopword : string -> bool

(** [filter tokens] removes stopwords from token list, preserving positions. *)
val filter : (string * int) list -> (string * int) list
