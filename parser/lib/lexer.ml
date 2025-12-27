type t =
  { input : string
  ; mutable pos : int
  }

(* Create a new lexer from input string *)
let create input = { input; pos = 0 }

(* Check if we've reached end of input *)
let is_at_end lexer = lexer.pos >= String.length lexer.input

(* Peek at current character without consuming *)
let peek lexer = if is_at_end lexer then None else Some lexer.input.[lexer.pos]

(* Advance to next character and return current *)
let advance lexer =
  let c = lexer.input.[lexer.pos] in
  lexer.pos <- lexer.pos + 1;
  c
;;

(* Skip whitespace *)
let rec skip_whitespace lexer =
  match peek lexer with
  | Some (' ' | '\t' | '\n' | '\r') ->
    ignore (advance lexer);
    skip_whitespace lexer
  | _ -> ()
;;

(* Check if character is alphanumeric or underscore *)
let is_word_char c =
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c = '_'
;;

(* Read a word (sequence of word characters) *)
let read_word lexer =
  let buf = Buffer.create 16 in
  let rec loop () =
    match peek lexer with
    | Some c when is_word_char c ->
      Buffer.add_char buf (advance lexer);
      loop ()
    | _ -> ()
  in
  loop ();
  Buffer.contents buf
;;

(* Get next token *)
let next_token lexer =
  skip_whitespace lexer;
  if is_at_end lexer
  then Token.EOF
  else (
    match peek lexer with
    | Some '(' ->
      ignore (advance lexer);
      Token.LPAREN
    | Some ')' ->
      ignore (advance lexer);
      Token.RPAREN
    | Some '"' ->
      ignore (advance lexer);
      Token.QUOTE
    | Some c when is_word_char c ->
      let word = read_word lexer in
      (* Check for keywords *)
      (match String.uppercase_ascii word with
       | "AND" -> Token.AND
       | "OR" -> Token.OR
       | "NOT" -> Token.NOT
       | _ -> Token.WORD (String.lowercase_ascii word))
    | Some c ->
      (* Skip unknown character *)
      ignore (advance lexer);
      next_token lexer
    | None -> Token.EOF)
;;
