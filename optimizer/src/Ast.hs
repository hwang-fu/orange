data Expr
  = Term String
  | Phrase [String]
  | And Expr Expr
  | Or Expr Expr
  | Not Expr
  deriving (Show, Eq)
