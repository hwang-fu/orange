type t =
  | AND (* AND keyword *)
  | OR (* OR keyword *)
  | NOT (* NOT keyword *)
  | LPAREN (* ( *)
  | RPAREN (* ) *)
  | QUOTE (* double quote character *)
  | WORD of string (* search term *)
  | EOF (* end of input *)

(* Convert token to string for debugging *)
let to_string = function
  | AND -> "AND"
  | OR -> "OR"
  | NOT -> "NOT"
  | LPAREN -> "LPAREN"
  | RPAREN -> "RPAREN"
  | QUOTE -> "QUOTE"
  | WORD w -> Printf.sprintf "WORD(%s)" w
  | EOF -> "EOF"
;;
