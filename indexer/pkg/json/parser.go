package json

import "errors"

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

// NewParser creates a new Parser for the given input string.
// It initializes the lexer and reads the first token.
func NewParser(input string) *Parser {
	p := &Parser{lexer: NewLexer(input)}
	p.advance() // load the first token
	return p
}

// advance moves to the next token from the lexer.
func (p *Parser) advance() {
	p.curr = p.lexer.Next()
}

// expect checks that the current token matches the expected type.
// If it matches, it advances to the next token.
// Returns an error if the token type doesn't match.
func (p *Parser) expect(t TokenType) error {
	if p.curr.Type != t {
		return errors.New("unexpected token")
	}
	p.advance()
	return nil
}
