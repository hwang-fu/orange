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
