let read_all () =
  let buf = Buffer.create 1024 in
  try
    while true do
      Buffer.add_channel buf stdin 1
    done;
    assert false
  with
  | End_of_file -> Buffer.contents buf
;;

let tokens_to_json tokens =
  let token_json (word, pos) =
    Printf.sprintf "{\"token\": \"%s\", \"pos\": %d}" word pos
  in
  "[" ^ String.concat ", " (List.map token_json tokens) ^ "]"
;;

let () =
  let text = read_all () in
  let tokens = Pumpkin_tokenizer.Lexer.tokenize text in
  print_endline (tokens_to_json tokens)
;;
