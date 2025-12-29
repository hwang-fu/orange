-- | Orange query optimizer entry point
-- Reads JSON AST from stdin, optimizes, outputs JSON AST to stdout
module Main where

import Lib (placeholder)

main :: IO ()
main = putStrLn placeholder
