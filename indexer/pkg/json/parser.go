package json

// TokenEntry represents a single token from the OCaml tokenizer.
// Matches the JSON format: {"token": "word", "pos": 0}
type TokenEntry struct {
	Token string // the normalized token text
	Pos   int    // position in the original document
}

type Parser struct {
	lexer *Lexer // the lexer providing tokens
	curr  Token  // current token being examined
}

// advance moves to the next token from the lexer.
func (p *Parser) advance() {
	p.curr = p.lexer.Next()
}
