import Ast (Expr (..))

-- | Convert Expr to JSON string
-- Output format matches OCaml parser's JSON format
toJson :: Expr -> String
toJson expr = case expr of
  Term s ->
    "{\"type\": \"term\", \"value\": \"" ++ escape s ++ "\"}"
  Phrase ws ->
    "{\"type\": \"phrase\", \"value\": \"" ++ escape (unwords ws) ++ "\"}"
  And l r ->
    "{\"type\": \"and\", \"left\": " ++ toJson l ++ ", \"right\": " ++ toJson r ++ "}"
  Or l r ->
    "{\"type\": \"or\", \"left\": " ++ toJson l ++ ", \"right\": " ++ toJson r ++ "}"
  Not e ->
    "{\"type\": \"not\", \"expr\": " ++ toJson e ++ "}"

-- | Escape special characters in strings
-- For now, just handle quotes and backslashes
escape :: String -> String
escape = concatMap escapeChar
  where
    escapeChar '"' = "\\\""
    escapeChar '\\' = "\\\\"
    escapeChar c = [c]
