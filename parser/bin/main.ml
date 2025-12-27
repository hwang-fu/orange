(* main.ml - Query parser CLI *)

let read_all () =
  let buf = Buffer.create 256 in
  try
    while true do
      Buffer.add_channel buf stdin 1
    done;
    assert false
  with
  | End_of_file -> Buffer.contents buf
;;

let () =
  let input = read_all () |> String.trim in
  if String.length input = 0
  then print_endline {|{"error": "empty input"}|}
  else (
    let ast = Parser.parse input in
    print_endline (Ast.to_json ast))
;;
