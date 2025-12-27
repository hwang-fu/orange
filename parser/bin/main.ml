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
