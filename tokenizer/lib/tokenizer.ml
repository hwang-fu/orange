let is_whitespace c = c = ' ' || c = '\t' || c = '\n' || c = '\r'

let split_words text =
  let len = String.length text in
  let rec loop i acc curr =
    if i >= len
    then if curr = "" then acc else curr :: acc
    else (
      let c = text.[i] in
      if is_whitespace c
      then if curr = "" then loop (i + 1) acc "" else loop (i + 1) (curr :: acc) ""
      else loop (i + 1) acc (curr ^ String.make 1 c))
  in
  List.rev (loop 0 [] "")
;;

let tokenize text =
  text
  |> String.trim
  |> split_words
  |> List.mapi (fun i word -> String.lowercase_ascii word, i)
;;
