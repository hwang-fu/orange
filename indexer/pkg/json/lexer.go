// Package json provides a hand-rolled JSON parser.
// It supports the subset needed for tokenizer output:
// arrays, objects, strings, and integers.
package json

// TokenType represents the type of a JSON lexical token.
type TokenType int

const (
	TokenLBracket TokenType = iota // [
	TokenRBracket                  // ]
	TokenLBrace                    // {
	TokenRBrace                    // }
	TokenColon                     // :
	TokenComma                     // ,
	TokenString                    // "..."
	TokenNumber                    // 123
	TokenEOF
	TokenError
)

type Token struct {
	Type  TokenType
	Value string // for strings and numbers, the actual value
}

type Lexer struct {
	input string
	pos   int
}

func NewLexer(input string) *Lexer {
	return &Lexer{input: input, pos: 0}
}

// skipWhitespace advances past any whitespace characters.
// Handles space, tab, newline, and carriage return.
func (l *Lexer) skipWhitespace() {
	for l.pos < len(l.input) {
		ch := l.input[l.pos]
		if ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r' {
			l.pos++
		} else {
			break
		}
	}
}

// readString reads a string literal (without escape sequence handling).
// Assumes the opening quote has NOT been consumed yet.
// Returns a TokenString with the content between quotes.
func (l *Lexer) readString() Token {
	l.pos++ // skip opening "
	start := l.pos

	// Read until closing quote
	for l.pos < len(l.input) && l.input[l.pos] != '"' {
		l.pos++
	}

	value := l.input[start:l.pos]
	l.pos++ // skip closing "

	return Token{Type: TokenString, Value: value}
}

// readNumber reads an integer literal (non-negative).
// Returns a TokenNumber with the digit sequence as a string.
func (l *Lexer) readNumber() Token {
	start := l.pos

	// Read consecutive digits
	for l.pos < len(l.input) && isDigit(l.input[l.pos]) {
		l.pos++
	}

	return Token{Type: TokenNumber, Value: l.input[start:l.pos]}
}

// isDigit checks if a byte is an ASCII digit (0-9).
func isDigit(ch byte) bool {
	return ch >= '0' && ch <= '9'
}
