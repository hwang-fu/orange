package index

// TokenWithPos is a simple struct for term + position pairs.
// Used as input to AddDocument.
type TokenWithPos struct {
	Token string
	Pos   int
}

// Posting represents a single occurrence of a term in a document.
// Contains the document ID and all positions where the term appears.
type Posting struct {
	DocID     string // unique document identifier
	Positions []int  // term positions within the document (for phrase queries later)
}

// PostingList contains all documents where a term appears.
// DocFreq is the number of documents (used for TF-IDF later).
type PostingList struct {
	DocFreq  int        // number of documents containing this term
	Postings []*Posting // list of postings, one per document
}

// InvertedIndex is the core search data structure.
// Maps each term to its posting list.
type InvertedIndex struct {
	terms    map[string]*PostingList // term -> posting list
	docCount int                     // total number of indexed documents
}

// New creates a new empty InvertedIndex.
func New() *InvertedIndex {
	return &InvertedIndex{
		terms:    make(map[string]*PostingList),
		docCount: 0,
	}
}

// Search returns all document IDs containing the given term.
// Returns empty slice if term not found.
func (idx *InvertedIndex) Search(term string) []string {
	pl, exists := idx.terms[term]
	if !exists {
		return []string{}
	}

	// Extract document IDs from postings
	docIDs := make([]string, len(pl.Postings))
	for i, p := range pl.Postings {
		docIDs[i] = p.DocID
	}
	return docIDs
}

// DocCount returns the total number of indexed documents.
func (idx *InvertedIndex) DocCount() int {
	return idx.docCount
}

// TermCount returns the number of unique terms in the index.
func (idx *InvertedIndex) TermCount() int {
	return len(idx.terms)
}
