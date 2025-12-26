package index

// inverted.go - In-memory inverted index for document search.
// Maps terms to posting lists (documents containing that term).

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
	TermFreq  int    // number of times term appears in this document
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

// AddDocument indexes a single document's tokens.
// docID is the unique identifier, tokens are (term, position) pairs.
func (idx *InvertedIndex) AddDocument(docID string, tokens []TokenWithPos) {
	// Group positions by term for this document
	termPositions := make(map[string][]int)
	for _, t := range tokens {
		termPositions[t.Token] = append(termPositions[t.Token], t.Pos)
	}

	// Add each term to the index
	for term, positions := range termPositions {
		// Get or create posting list for this term
		pl, exists := idx.terms[term]
		if !exists {
			pl = &PostingList{
				DocFreq:  0,
				Postings: make([]*Posting, 0),
			}
			idx.terms[term] = pl
		}

		// Add posting for this document
		posting := &Posting{
			DocID:     docID,
			TermFreq:  len(positions),
			Positions: positions,
		}
		pl.Postings = append(pl.Postings, posting)
		pl.DocFreq++
	}

	idx.docCount++
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
