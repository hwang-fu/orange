(* Check if a character is a vowel.
   Note: 'y' is treated as a consonant at word start, vowel otherwise. *)
let is_vowel word i =
  let c = word.[i] in
  match c with
  | 'a' | 'e' | 'i' | 'o' | 'u' -> true
  | 'y' -> i > 0 (* y is vowel only if not at start *)
  | _ -> false
;;

(* Check if a character is a consonant *)
let is_consonant word i = not (is_vowel word i)
