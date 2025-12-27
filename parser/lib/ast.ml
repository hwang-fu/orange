type expr =
  | Term of string (* single word: search *)
  | Phrase of string list (* quoted phrase: "search engine" *)
  | And of expr * expr (* expr AND expr *)
  | Or of expr * expr (* expr OR expr *)
  | Not of expr (* NOT expr *)
