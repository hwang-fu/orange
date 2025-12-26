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

// Next returns the next token from the input.
// It skips whitespace and advances the position.
// Returns TokenEOF when input is exhausted.
func (l *Lexer) Next() Token {
	// Skip any whitespace before the next token
	l.skipWhitespace()

	// Check for end of input
	if l.pos >= len(l.input) {
		return Token{Type: TokenEOF}
	}

	ch := l.input[l.pos]

	// Match single-character tokens
	switch ch {
	case '[':
		l.pos++
		return Token{Type: TokenLBracket}
	case ']':
		l.pos++
		return Token{Type: TokenRBracket}
	case '{':
		l.pos++
		return Token{Type: TokenLBrace}
	case '}':
		l.pos++
		return Token{Type: TokenRBrace}
	case ':':
		l.pos++
		return Token{Type: TokenColon}
	case ',':
		l.pos++
		return Token{Type: TokenComma}
	case '"':
		// String literals start with a double quote
		return l.readString()
	default:
		// Numbers start with a digit
		if isDigit(ch) {
			return l.readNumber()
		}
		// Unknown character - return error token
		return Token{Type: TokenError, Value: string(ch)}
	}
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
