let tokenize text =
  text
  |> String.trim
  |> String.split_on_char ' '
  |> List.filter (fun s -> String.length s > 0)
  |> List.map String.lowercase_ascii
