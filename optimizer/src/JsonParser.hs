import Ast (Expr (..))
import JsonLexer (Token (..), lexJson)

-- | Parse error description
type ParseError = String

-- | Expect closing brace
expectRBrace :: [Token] -> Either ParseError [Token]
expectRBrace (TokRBrace : rest) = Right rest
expectRBrace (TokComma : TokRBrace : rest) = Right rest -- trailing comma ok
expectRBrace _ = Left "Expected '}'"
