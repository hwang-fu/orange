(* stopwords.ml - Common English stopwords for filtering *)

(* A set of common English stopwords to be filtered from token streams.
   These words appear frequently but carry little semantic value for search. *)
let words =
  [ "a"
  ; "an"
  ; "and"
  ; "are"
  ; "as"
  ; "at"
  ; "be"
  ; "by"
  ; "for"
  ; "from"
  ; "has"
  ; "he"
  ; "in"
  ; "is"
  ; "it"
  ; "its"
  ; "of"
  ; "on"
  ; "that"
  ; "the"
  ; "to"
  ; "was"
  ; "were"
  ; "will"
  ; "with"
  ; "this"
  ; "but"
  ; "they"
  ; "have"
  ; "had"
  ; "what"
  ; "when"
  ; "where"
  ; "who"
  ; "which"
  ; "why"
  ; "how"
  ]
;;

(* Check if a word is a stopword.
   Returns true if the word should be filtered out. *)
let is_stopword word = List.mem word words

(* Filter out stopwords from a list of (token, position) pairs.
   Positions are preserved from the original text. *)
let filter tokens = List.filter (fun (word, _) -> not (is_stopword word)) tokens
