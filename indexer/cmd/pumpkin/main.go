package main

// main.go - CLI entry point for the pumpkin indexer.
// Supports two modes: index (build from stdin) and query (search).

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"pumpkin/internal/index"
	"pumpkin/pkg/json"
)

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(1)
	}

	switch os.Args[1] {
	case "index":
		runIndex()
	case "query":
		runQuery()
	default:
		fmt.Fprintf(os.Stderr, "unknown command: %s\n", os.Args[1])
		printUsage()
		os.Exit(1)
	}
}

// runQuery is reserved for future use (e.g., query against persisted index).
func runQuery() {
	fmt.Println("query mode not yet implemented")
	fmt.Println("use 'index' mode to build and query interactively")
}

// runIndex reads tokenizer output from stdin and builds an inverted index.
// If query terms are provided as arguments, searches for them.
func runIndex() {
	// Create a new index
	idx := index.New()

	// Read JSON lines from stdin
	scanner := bufio.NewScanner(os.Stdin)
	docNum := 0

	for scanner.Scan() {
		line := scanner.Text()
		if strings.TrimSpace(line) == "" {
			continue
		}

		// Parse the JSON
		parser := json.NewParser(line)
		entries, err := parser.ParseTokenEntries()
		if err != nil {
			fmt.Fprintf(os.Stderr, "parse error on line %d: %v\n", docNum+1, err)
			continue
		}

		// Convert to TokenWithPos slice
		tokens := make([]index.TokenWithPos, len(entries))
		for i, e := range entries {
			tokens[i] = index.TokenWithPos{
				Token: e.Token,
				Pos:   e.Pos,
			}
		}

		// Generate document ID and add to index
		docID := fmt.Sprintf("doc_%d", docNum)
		idx.AddDocument(docID, tokens)
		docNum++
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "read error: %v\n", err)
		os.Exit(1)
	}

	// Print index stats to stderr
	fmt.Fprintf(os.Stderr, "Indexed %d documents, %d unique terms\n", idx.DocCount(), idx.TermCount())

	// Query terms from command line arguments
	// Usage: pumpkin index <term1> <term2> ...
	if len(os.Args) < 3 {
		fmt.Fprintln(os.Stderr, "usage: pumpkin index <query-term> [<query-term>...]")
		return
	}

	for _, term := range os.Args[2:] {
		results := idx.Search(term)
		if len(results) == 0 {
			fmt.Printf("'%s': no results\n", term)
		} else {
			fmt.Printf("'%s': %v\n", term, results)
		}
	}
}

// printUsage displays help information.
func printUsage() {
	fmt.Fprintln(os.Stderr, "usage: pumpkin <command> [args]")
	fmt.Fprintln(os.Stderr, "")
	fmt.Fprintln(os.Stderr, "commands:")
	fmt.Fprintln(os.Stderr, "  index <term>...   read tokens from stdin, build index, query for terms")
	fmt.Fprintln(os.Stderr, "  query             (reserved for future use)")
}
