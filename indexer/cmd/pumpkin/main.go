package main

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
