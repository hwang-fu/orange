type t =
  { lexer : Lexer.t
  ; mutable current : Token.t
  }

(* Create parser from input string *)
let create input =
  let lexer = Lexer.create input in
  let current = Lexer.next_token lexer in
  { lexer; current }
;;

(* Advance to next token *)
let advance parser = parser.current <- Lexer.next_token parser.lexer

(* Check if current token matches expected type *)
let check parser token = parser.current = token

(* Consume token if it matches, otherwise return false *)
let match_token parser token =
  if check parser token
  then (
    advance parser;
    true)
  else false
;;

(* Parse a phrase: "word1 word2 ..." *)
let parse_phrase parser =
  let rec collect_words acc =
    match parser.current with
    | Token.WORD w ->
      advance parser;
      collect_words (w :: acc)
    | Token.QUOTE ->
      advance parser;
      List.rev acc
    | _ ->
      (* Missing closing quote - return what we have *)
      List.rev acc
  in
  let words = collect_words [] in
  Ast.Phrase words
;;
