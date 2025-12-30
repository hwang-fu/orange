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
