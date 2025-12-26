package json

import (
	"errors"
	"strconv"
)

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

// ParseTokenEntries parses the full tokenizer output.
// Expects format: [{"token": "...", "pos": N}, ...]
// Returns a slice of TokenEntry structs.
func (p *Parser) ParseTokenEntries() ([]TokenEntry, error) {
	var entries []TokenEntry

	// Expect opening bracket
	if err := p.expect(TokenLBracket); err != nil {
		return nil, errors.New("expected '[' at start")
	}

	// Handle empty array
	if p.curr.Type == TokenRBracket {
		p.advance()
		return entries, nil
	}

	// Parse first entry
	entry, err := p.parseOneEntry()
	if err != nil {
		return nil, err
	}
	entries = append(entries, entry)

	// Parse remaining entries (comma-separated)
	for p.curr.Type == TokenComma {
		p.advance() // consume comma

		entry, err := p.parseOneEntry()
		if err != nil {
			return nil, err
		}
		entries = append(entries, entry)
	}

	// Expect closing bracket
	if err := p.expect(TokenRBracket); err != nil {
		return nil, errors.New("expected ']' at end")
	}

	return entries, nil
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

// parseOneEntry parses a single {"token": "...", "pos": N} object.
// Returns a TokenEntry with the extracted values.
func (p *Parser) parseOneEntry() (TokenEntry, error) {
	var entry TokenEntry

	// Expect opening brace
	if err := p.expect(TokenLBrace); err != nil {
		return entry, errors.New("expected '{' for entry")
	}

	// Parse two key-value pairs (order may vary)
	for i := 0; i < 2; i++ {
		if i > 0 {
			// Expect comma between pairs
			if err := p.expect(TokenComma); err != nil {
				return entry, errors.New("expected ',' between fields")
			}
		}

		// Get the key
		if p.curr.Type != TokenString {
			return entry, errors.New("expected string key")
		}
		key := p.curr.Value
		p.advance()

		// Expect colon
		if err := p.expect(TokenColon); err != nil {
			return entry, errors.New("expected ':' after key")
		}

		// Get the value based on key
		switch key {
		case "token":
			if p.curr.Type != TokenString {
				return entry, errors.New("expected string for 'token'")
			}
			entry.Token = p.curr.Value
			p.advance()

		case "pos":
			if p.curr.Type != TokenNumber {
				return entry, errors.New("expected number for 'pos'")
			}
			pos, err := strconv.Atoi(p.curr.Value)
			if err != nil {
				return entry, errors.New("invalid position number")
			}
			entry.Pos = pos
			p.advance()

		default:
			return entry, errors.New("unknown key: " + key)
		}
	}

	// Expect closing brace
	if err := p.expect(TokenRBrace); err != nil {
		return entry, errors.New("expected '}' after entry")
	}

	return entry, nil
}
