package index

// SearchResult represents a document with its relevance score.
type SearchResult struct {
	DocID string  // document identifier
	Score float64 // TF-IDF relevance score
}
