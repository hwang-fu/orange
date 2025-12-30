-- | AST types for query expressions
-- Mirrors the OCaml parser's AST for interoperability
module Ast
  ( Expr (..),
  )
where

-- \| Query expression AST
-- Each constructor corresponds to OCaml's expr type
data Expr
  = -- | Single search term
    Term String
  | -- | Exact phrase (quoted words)
    Phrase [String]
  | -- | Boolean AND
    And Expr Expr
  | -- | Boolean OR
    Or Expr Expr
  | -- | Boolean NOT
    Not Expr
  deriving (Show, Eq)
