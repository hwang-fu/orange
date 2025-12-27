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

(* Forward declaration for mutual recursion *)
let parse_expr parser = failwith "not implemented"

(* Parse a factor: WORD | PHRASE | '(' expr ')' *)
let rec parse_factor parser =
  match parser.current with
  | Token.WORD w ->
    advance parser;
    Ast.Term w
  | Token.QUOTE ->
    advance parser;
    parse_phrase parser
  | Token.LPAREN ->
    advance parser;
    let expr = parse_or parser in
    if check parser Token.RPAREN then advance parser;
    expr
  | _ ->
    (* Default to empty term - error recovery *)
    Ast.Term ""

(* Parse a term: NOT? factor *)
and parse_term parser =
  if match_token parser Token.NOT
  then Ast.Not (parse_factor parser)
  else parse_factor parser

(* Parse AND expressions: term (AND term)* *)
and parse_and parser =
  let left = parse_term parser in
  let rec loop left =
    if match_token parser Token.AND
    then (
      let right = parse_term parser in
      loop (Ast.And (left, right)))
    else (
      (* Implicit AND: two terms next to each other *)
      match parser.current with
      | Token.WORD _ | Token.QUOTE | Token.LPAREN | Token.NOT ->
        let right = parse_term parser in
        loop (Ast.And (left, right))
      | _ -> left)
  in
  loop left

(* Parse OR expressions: and_expr (OR and_expr)* *)
and parse_or parser =
  let left = parse_and parser in
  let rec loop left =
    if match_token parser Token.OR
    then (
      let right = parse_and parser in
      loop (Ast.Or (left, right)))
    else left
  in
  loop left
;;

(* Main parse function *)
let parse input =
  let parser = create input in
  parse_or parser
;;
