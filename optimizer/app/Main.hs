-- | Orange query optimizer entry point
-- Reads JSON AST from stdin, optimizes, outputs JSON AST to stdout
module Main where

import Emit (toJson)
import JsonParser (parseExpr)
import Lib (placeholder)
import Simplify (simplify)
import System.IO (hFlush, stdout)

main :: IO ()
main = do
  -- Read all input from stdin
  input <- getContents

  -- Parse, simplify, emit
  case parseExpr input of
    Left err -> do
      putStrLn $ "Error: " ++ err
    Right expr -> do
      let optimized = simplify expr
      putStrLn (toJson optimized)
      hFlush stdout
