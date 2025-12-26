package main

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

// runIndex reads tokenizer output from stdin and builds an inverted index.
// Then enters interactive query mode.
func runIndex() {
	// Create a new index
	idx := index.New()

	// Read JSON lines from stdin
	// Each line is a document: [{"token": "...", "pos": N}, ...]
	scanner := bufio.NewScanner(os.Stdin)
	docNum := 0

	fmt.Fprintln(os.Stderr, "Reading documents from stdin (one JSON array per line)...")
	fmt.Fprintln(os.Stderr, "Press Ctrl+D when done.")
	fmt.Fprintln(os.Stderr, "")

	for scanner.Scan() {
		line := scanner.Text()
		if strings.TrimSpace(line) == "" {
			continue // skip empty lines
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

	// Print index stats
	fmt.Fprintln(os.Stderr, "")
	fmt.Fprintf(os.Stderr, "Indexed %d documents, %d unique terms\n", idx.DocCount(), idx.TermCount())
	fmt.Fprintln(os.Stderr, "")

	// Enter interactive query mode
	fmt.Fprintln(os.Stderr, "Enter search terms (one per line, Ctrl+D to exit):")
	queryScanner := bufio.NewScanner(os.Stdin)

	for queryScanner.Scan() {
		term := strings.TrimSpace(queryScanner.Text())
		if term == "" {
			continue
		}

		// Search the index
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
	fmt.Fprintln(os.Stderr, "usage: pumpkin <command>")
	fmt.Fprintln(os.Stderr, "")
	fmt.Fprintln(os.Stderr, "commands:")
	fmt.Fprintln(os.Stderr, "  index    read token JSON from stdin, build index, then query interactively")
	fmt.Fprintln(os.Stderr, "  query    (reserved for future use)")
}
