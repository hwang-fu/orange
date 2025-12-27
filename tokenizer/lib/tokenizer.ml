(* tokenizer.ml - Splits raw text into lowercase tokens with positions *)

(* Characters considered whitespace for splitting *)
let is_whitespace c = c = ' ' || c = '\t' || c = '\n' || c = '\r'

(* Split text into words on whitespace boundaries.
   Returns words in original order. *)
let split_words text =
  let len = String.length text in
  let rec scan index words current_word =
    if index >= len
    then
      (* End of text: add final word if non-empty *)
      if current_word = "" then words else current_word :: words
    else (
      let c = text.[index] in
      if is_whitespace c
      then
        (* Whitespace: save current word if non-empty, start fresh *)
        if current_word = ""
        then scan (index + 1) words ""
        else scan (index + 1) (current_word :: words) ""
      else
        (* Character: append to current word *)
        scan (index + 1) words (current_word ^ String.make 1 c))
  in
  List.rev (scan 0 [] "")
;;

(* Tokenize text: trim, split on whitespace, lowercase, add positions.
     Returns list of (token, position) pairs. *)
let tokenize text =
  text
  |> String.trim
  |> split_words
  |> List.mapi (fun position word -> String.lowercase_ascii word, position)
;;
