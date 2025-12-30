import Ast (Expr (..))

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
