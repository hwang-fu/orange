package main

// main.go - CLI entry point for the pumpkin indexer.
// Supports two modes: index (build from stdin) and query (search).

import (
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "usage: pumpkin <command>")
		os.Exit(1)
	}

	switch os.Args[1] {
	case "index":
		fmt.Println("index mode (not implemented)")
	case "query":
		fmt.Println("query mode (not implemented)")
	default:
		fmt.Fprintf(os.Stderr, "unknown command: %s\n", os.Args[1])
		os.Exit(1)
	}
}

// printUsage displays help information.
func printUsage() {
	fmt.Fprintln(os.Stderr, "usage: pumpkin <command>")
	fmt.Fprintln(os.Stderr, "")
	fmt.Fprintln(os.Stderr, "commands:")
	fmt.Fprintln(os.Stderr, "  index    read token JSON from stdin, build index, then query interactively")
	fmt.Fprintln(os.Stderr, "  query    (reserved for future use)")
}
