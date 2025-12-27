type t =
  | AND (* AND keyword *)
  | OR (* OR keyword *)
  | NOT (* NOT keyword *)
  | LPAREN (* ( *)
  | RPAREN (* ) *)
  | QUOTE (* double quote character *)
  | WORD of string (* search term *)
  | EOF (* end of input *)
