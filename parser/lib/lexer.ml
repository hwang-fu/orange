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
