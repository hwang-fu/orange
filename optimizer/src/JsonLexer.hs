-- Tokenizes JSON input for the parser
module JsonLexer
  ( Token (..),
    lexJson,
  )
where

-- \| JSON tokens
data Token
  = -- | {
    TokLBrace
  | -- | }
    TokRBrace
  | -- | [
    TokLBracket
  | -- | ]
    TokRBracket
  | -- | :
    TokColon
  | -- | ,
    TokComma
  | -- | "..."
    TokString String
  | -- | end of input
    TokEOF
  deriving (Show, Eq)

lexJson :: String -> [Token]
lexJson = go
  where
    go [] = [TokEOF]
    go (c : cs)
      | isSpace c = go cs -- skip whitespace
      | c == '{' = TokLBrace : go cs
      | c == '}' = TokRBrace : go cs
      | c == '[' = TokLBracket : go cs
      | c == ']' = TokRBracket : go cs
      | c == ':' = TokColon : go cs
      | c == ',' = TokComma : go cs
      | c == '"' = lexString cs -- start of string
      | otherwise = go cs -- skip unknown

    --
    isSpace c = c == ' ' || c == '\n' || c == '\t' || c == '\r'

    -- Read string contents until closing quote
    lexString cs =
      let (str, rest) = span (/= '"') cs
       in case rest of
            ('"' : rs) -> TokString str : go rs -- consume closing quote
            _ -> [TokEOF] -- unterminated string
