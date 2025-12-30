-- | Boolean simplification rules for query AST
-- Applies rewrite rules to optimize queries
module Simplify
  ( simplify,
  )
where

import Ast (Expr (..))

-- | Apply simplification rules recursively
-- Simplifies children first (bottom-up), then applies rules at current node
simplify :: Expr -> Expr
simplify expr =
  let simplified = case expr of
        -- Recursively simplify children first
        And l r -> And (simplify l) (simplify r)
        Or l r -> Or (simplify l) (simplify r)
        Not e -> Not (simplify e)
        -- Leaves stay as-is
        other -> other
   in applyRules simplified

-- | Apply rewrite rules at current node
applyRules :: Expr -> Expr
applyRules expr = case expr of
  -- Double negation: NOT (NOT x) → x
  Not (Not x) -> x
  -- Idempotent AND: x AND x → x
  And x y | x == y -> x
  -- Idempotent OR: x OR x → x
  Or x y | x == y -> x
  -- No rule applies
  _ -> expr
