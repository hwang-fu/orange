package main

import (
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		printUsage()
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

// runQuery is reserved for future use (e.g., query against persisted index).
func runQuery() {
	fmt.Println("query mode not yet implemented")
	fmt.Println("use 'index' mode to build and query interactively")
}

// printUsage displays help information.
func printUsage() {
	fmt.Fprintln(os.Stderr, "usage: pumpkin <command>")
	fmt.Fprintln(os.Stderr, "")
	fmt.Fprintln(os.Stderr, "commands:")
	fmt.Fprintln(os.Stderr, "  index    read token JSON from stdin, build index, then query interactively")
	fmt.Fprintln(os.Stderr, "  query    (reserved for future use)")
}
