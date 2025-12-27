(* stemmer.ml - Porter Stemmer implementation

   The Porter stemming algorithm reduces words to their root form
   by applying a series of suffix-stripping rules in 5 steps.

   Reference: https://tartarus.org/martin/PorterStemmer/ *)

(* ============================================================
   Character Classification
   ============================================================ *)

(* Check if character at position [i] in [word] is a vowel.
   Note: 'y' is a vowel only when not at word start. *)
let is_vowel word i =
  match word.[i] with
  | 'a' | 'e' | 'i' | 'o' | 'u' -> true
  | 'y' -> i > 0
  | _ -> false
;;

(* Check if character at position [i] in [word] is a consonant. *)
let is_consonant word i = not (is_vowel word i)

(* Check if [word] contains at least one vowel. *)
let contains_vowel word =
  let len = String.length word in
  let rec scan i =
    if i >= len then false else if is_vowel word i then true else scan (i + 1)
  in
  scan 0
;;

(* ============================================================
   String Helpers
   ============================================================ *)

(* Check if [word] ends with [suffix]. *)
let ends_with word suffix =
  let word_len = String.length word in
  let suffix_len = String.length suffix in
  if suffix_len > word_len
  then false
  else String.sub word (word_len - suffix_len) suffix_len = suffix
;;

(* Remove the last [n] characters from [word]. *)
let remove_last word n =
  let len = String.length word in
  if n >= len then "" else String.sub word 0 (len - n)
;;

(* Check if [word] ends with a double consonant (e.g., "hopp", "fall"). *)
let ends_with_double_consonant word =
  let len = String.length word in
  if len < 2
  then false
  else (
    let last = word.[len - 1] in
    let second_last = word.[len - 2] in
    last = second_last && is_consonant word (len - 1))
;;

(* Check if [word] ends with consonant-vowel-consonant pattern,
   where the final consonant is not 'w', 'x', or 'y'.
   Used to determine when to restore 'e' after suffix removal. *)
let ends_with_cvc word =
  let len = String.length word in
  if len < 3
  then false
  else (
    let last_char = word.[len - 1] in
    is_consonant word (len - 3)
    && is_vowel word (len - 2)
    && is_consonant word (len - 1)
    && last_char <> 'w'
    && last_char <> 'x'
    && last_char <> 'y')
;;

(* ============================================================
   Word Measure
   ============================================================ *)

(* Calculate the "measure" of a word.
   Measure (m) = number of vowel-consonant (VC) sequences.

   Examples:
     "tree"    -> 0  (no VC after initial consonants)
     "trouble" -> 1  (tr-ou-ble = 1 VC sequence)
     "private" -> 2  (pr-i-v-ate = 2 VC sequences) *)
let measure word =
  let len = String.length word in
  if len = 0
  then 0
  else (
    (* Skip leading consonants to find first vowel *)
    let rec skip_leading_consonants i =
      if i >= len
      then i
      else if is_vowel word i
      then i
      else skip_leading_consonants (i + 1)
    in
    (* Count VC transitions *)
    let rec count_vc_sequences i was_vowel count =
      if i >= len
      then count
      else (
        let current_is_vowel = is_vowel word i in
        if was_vowel && not current_is_vowel
        then
          (* Transition from vowel to consonant: increment count *)
          count_vc_sequences (i + 1) false (count + 1)
        else count_vc_sequences (i + 1) current_is_vowel count)
    in
    let start = skip_leading_consonants 0 in
    count_vc_sequences start false 0)
;;

(* ============================================================
     Step 1: Plurals, Past Tense, -y
     ============================================================ *)

(* Step 1a: Remove plural suffixes (-s, -es). *)
let step1a word =
  if ends_with word "sses"
  then remove_last word 2 (* sses -> ss *)
  else if ends_with word "ies"
  then remove_last word 2 (* ies -> i *)
  else if ends_with word "ss"
  then word (* ss -> ss *)
  else if ends_with word "s"
  then remove_last word 1 (* s -> remove *)
  else word
;;

(* Step 1b helper: Fix stem after removing -ed/-ing.
     Handles special cases like "hopping" -> "hop" + restore "e". *)
let rec step1b_fix stem =
  if ends_with stem "at"
  then stem ^ "e"
  else if ends_with stem "bl"
  then stem ^ "e"
  else if ends_with stem "iz"
  then stem ^ "e"
  else if ends_with_double_consonant stem
  then (
    let last = stem.[String.length stem - 1] in
    (* Don't remove double l, s, or z *)
    if last <> 'l' && last <> 's' && last <> 'z' then remove_last stem 1 else stem)
  else if measure stem = 1 && ends_with_cvc stem
  then stem ^ "e"
  else stem

(* Step 1b: Remove past tense and progressive suffixes (-ed, -ing). *)
and step1b word =
  if ends_with word "eed"
  then (
    let stem = remove_last word 3 in
    if measure stem > 0 then remove_last word 1 else word)
  else if ends_with word "ed"
  then (
    let stem = remove_last word 2 in
    if contains_vowel stem then step1b_fix stem else word)
  else if ends_with word "ing"
  then (
    let stem = remove_last word 3 in
    if contains_vowel stem then step1b_fix stem else word)
  else word
;;

(* Step 1c: Replace suffix -y with -i, handle -fully compound. *)
let step1c word =
  if ends_with word "fully"
  then (
    let stem = remove_last word 5 in
    if measure stem > 0 then stem else word)
  else if ends_with word "y"
  then (
    let stem = remove_last word 1 in
    if contains_vowel stem then stem ^ "i" else word)
  else word
;;

(* ============================================================
     Steps 2-4: Suffix Mapping and Removal
     ============================================================ *)

(* Helper: Try to replace [suffix] with [replacement] if measure > 0. *)
let try_replace_m0 word suffix replacement =
  if ends_with word suffix
  then (
    let stem = remove_last word (String.length suffix) in
    if measure stem > 0 then Some (stem ^ replacement) else None)
  else None
;;

(* Helper: Try to remove [suffix] if measure > 1. *)
let try_remove_m1 word suffix =
  if ends_with word suffix
  then (
    let stem = remove_last word (String.length suffix) in
    if measure stem > 1 then Some stem else None)
  else None
;;

(* Helper: Apply first matching rule from a list of (suffix, replacement) pairs. *)
let rec apply_first_rule word rules try_fn =
  match rules with
  | [] -> word
  | (suffix, replacement) :: rest ->
    (match try_fn word suffix replacement with
     | Some result -> result
     | None -> apply_first_rule word rest try_fn)
;;

(* Step 2: Map double suffixes to simpler forms (m > 0). *)
let step2 word =
  let rules =
    [ "ational", "ate"
    ; "tional", "tion"
    ; "enci", "ence"
    ; "anci", "ance"
    ; "izer", "ize"
    ; "abli", "able"
    ; "alli", "al"
    ; "entli", "ent"
    ; "eli", "e"
    ; "ousli", "ous"
    ; "ization", "ize"
    ; "ation", "ate"
    ; "ator", "ate"
    ; "alism", "al"
    ; "iveness", "ive"
    ; "fulness", "ful"
    ; "ousness", "ous"
    ; "aliti", "al"
    ; "iviti", "ive"
    ; "biliti", "ble"
    ]
  in
  apply_first_rule word rules try_replace_m0
;;

(* Step 3: Map derivational suffixes (m > 0). *)
let step3 word =
  let rules =
    [ "icate", "ic"
    ; "ative", ""
    ; "alize", "al"
    ; "iciti", "ic"
    ; "ical", "ic"
    ; "ful", ""
    ; "ness", ""
    ]
  in
  apply_first_rule word rules try_replace_m0
;;

(* Step 4: Remove suffixes (m > 1). *)
let step4 word =
  (* Special case: -ion requires stem ending in 's' or 't' *)
  let try_remove_ion () =
    if ends_with word "ion"
    then (
      let stem = remove_last word 3 in
      if measure stem > 1 && (ends_with stem "s" || ends_with stem "t")
      then Some stem
      else None)
    else None
  in
  let suffixes =
    [ "al"
    ; "ance"
    ; "ence"
    ; "er"
    ; "ic"
    ; "able"
    ; "ible"
    ; "ant"
    ; "ement"
    ; "ment"
    ; "ent"
    ; "ou"
    ; "ism"
    ; "ate"
    ; "iti"
    ; "ous"
    ; "ive"
    ; "ize"
    ]
  in
  let rec try_suffixes = function
    | [] ->
      (match try_remove_ion () with
       | Some w -> w
       | None -> word)
    | suffix :: rest ->
      (match try_remove_m1 word suffix with
       | Some w -> w
       | None -> try_suffixes rest)
  in
  try_suffixes suffixes
;;

(* ============================================================
     Step 5: Final Cleanup
     ============================================================ *)

(* Step 5: Remove trailing -e and reduce -ll to -l. *)
let step5 word =
  (* Step 5a: Remove trailing 'e' under certain conditions *)
  let word =
    if ends_with word "e"
    then (
      let stem = remove_last word 1 in
      let m = measure stem in
      if m > 1 then stem else if m = 1 && not (ends_with_cvc stem) then stem else word)
    else word
  in
  (* Step 5b: Reduce 'll' to 'l' if m > 1 *)
  if measure word > 1 && ends_with word "ll" then remove_last word 1 else word
;;

(* ============================================================
     Public API
     ============================================================ *)

(* Stem a word using the Porter algorithm.
     Words with 2 or fewer characters are returned unchanged. *)
let stem word =
  if String.length word <= 2
  then word
  else word |> step1a |> step1b |> step1c |> step2 |> step3 |> step4 |> step5
;;

(* Apply stemming to each token in a list. *)
let apply tokens = List.map (fun (word, pos) -> stem word, pos) tokens
