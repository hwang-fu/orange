package json

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
