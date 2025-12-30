import Ast (Expr (..))
import JsonLexer (Token (..), lexJson)

-- | Parse error description
type ParseError = String
