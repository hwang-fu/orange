package index

import (
	"math"
	"sort"
)

// SearchResult represents a document with its relevance score.
type SearchResult struct {
	DocID string  // document identifier
	Score float64 // TF-IDF relevance score
}

// SearchWithScore returns documents matching the term, ranked by TF-IDF score.
// Results are sorted in descending order (highest score first).
func (idx *InvertedIndex) SearchWithScore(term string) []SearchResult {
	pl, exists := idx.terms[term]
	if !exists {
		return []SearchResult{}
	}

	// Calculate IDF: log(totalDocs / docsContainingTerm)
	// Adding 1 to avoid division by zero and log(0)
	idf := math.Log(float64(idx.docCount+1) / float64(pl.DocFreq+1))

	// Calculate TF-IDF for each document
	results := make([]SearchResult, len(pl.Postings))
	for i, p := range pl.Postings {
		// TF: term frequency in this document
		tf := float64(p.TermFreq)

		// TF-IDF score
		score := tf * idf

		results[i] = SearchResult{
			DocID: p.DocID,
			Score: score,
		}
	}

	// Sort by score descending (highest first)
	sort.Slice(results, func(i, j int) bool {
		return results[i].Score > results[j].Score
	})

	return results
}
