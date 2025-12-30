-- | Orange query optimizer entry point
-- Reads JSON AST from stdin, optimizes, outputs JSON AST to stdout
module Main where

import Emit (toJson)
import JsonParser (parseExpr)
import Lib (placeholder)
import Simplify (simplify)

main :: IO ()
main = putStrLn placeholder
