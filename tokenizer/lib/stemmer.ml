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

(* Check if word contains a vowel *)
let has_vowel word =
  let len = String.length word in
  let rec loop i =
    if i >= len then false else if is_vowel word i then true else loop (i + 1)
  in
  loop 0
;;

(* Check if word ends with given suffix *)
let ends_with word suffix =
  let wlen = String.length word in
  let slen = String.length suffix in
  if slen > wlen then false else String.sub word (wlen - slen) slen = suffix
;;

(* Remove n characters from end of word *)
let chop word n =
  let len = String.length word in
  if n >= len then "" else String.sub word 0 (len - n)
;;

(* Check if word ends with double consonant (e.g., "hopp", "fall") *)
let ends_double_consonant word =
  let len = String.length word in
  if len < 2
  then false
  else (
    let c1 = word.[len - 1] in
    let c2 = word.[len - 2] in
    c1 = c2 && is_consonant word (len - 1))
;;

(* Calculate the measure (m) of a word.
   Measure = number of VC (vowel-consonant) sequences. *)
let measure word =
  let len = String.length word in
  if len = 0
  then 0
  else (
    let rec loop i in_vowel count =
      if i >= len
      then count
      else (
        let v = is_vowel word i in
        if in_vowel && not v
        then
          (* transition from vowel to consonant = +1 *)
          loop (i + 1) false (count + 1)
        else loop (i + 1) v count)
    in
    (* skip initial consonants *)
    let rec skip_initial_c i =
      if i >= len then i else if is_vowel word i then i else skip_initial_c (i + 1)
    in
    let start = skip_initial_c 0 in
    loop start false 0)
;;
