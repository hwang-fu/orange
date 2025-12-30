import Ast (Expr (..))
import JsonLexer (Token (..), lexJson)

-- | Parse error description
type ParseError = String

-- | Skip optional comma
skipComma :: [Token] -> [Token]
skipComma (TokComma : rest) = rest
skipComma tokens = tokens

-- | Expect closing brace
expectRBrace :: [Token] -> Either ParseError [Token]
expectRBrace (TokRBrace : rest) = Right rest
expectRBrace (TokComma : TokRBrace : rest) = Right rest -- trailing comma ok
expectRBrace _ = Left "Expected '}'"

-- | Expect comma (optional at end), then "key": "string value"
expectKey :: String -> [Token] -> Either ParseError (String, [Token])
expectKey key tokens =
  let tokens' = skipComma tokens
   in case tokens' of
        (TokString k : TokColon : TokString v : rest)
          | k == key -> Right (v, rest)
          | otherwise -> Left $ "Expected key '" ++ key ++ "', got '" ++ k ++ "'"
        _ -> Left $ "Expected key '" ++ key ++ "'"

-- | Parse Term: expect "value": "..."
parseTerm :: [Token] -> Either ParseError (Expr, [Token])
parseTerm tokens = do
  (val, rest) <- expectKey "value" tokens
  rest' <- expectRBrace rest
  Right (Term val, rest')
