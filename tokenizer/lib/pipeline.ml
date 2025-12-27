(* pipeline.ml - Orchestrates the text processing pipeline *)

(* Process raw text through the full pipeline:
     tokenize -> remove stopwords -> stem *)
let process text =
  text |> Tokenizer.tokenize |> Tokenizer.remove_stopwords |> Tokenizer.stem_tokens
;;
