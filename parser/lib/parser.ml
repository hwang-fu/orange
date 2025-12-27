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
