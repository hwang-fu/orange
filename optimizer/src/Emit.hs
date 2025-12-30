import Ast (Expr (..))

-- | Escape special characters in strings
-- For now, just handle quotes and backslashes
escape :: String -> String
escape = concatMap escapeChar
  where
    escapeChar '"' = "\\\""
    escapeChar '\\' = "\\\\"
    escapeChar c = [c]
