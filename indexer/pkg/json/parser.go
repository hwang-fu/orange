package json

// TokenEntry represents a single token from the OCaml tokenizer.
// Matches the JSON format: {"token": "word", "pos": 0}
type TokenEntry struct {
	Token string // the normalized token text
	Pos   int    // position in the original document
}
