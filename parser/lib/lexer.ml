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
