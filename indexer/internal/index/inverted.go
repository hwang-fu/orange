package index

// Posting represents a single occurrence of a term in a document.
// Contains the document ID and all positions where the term appears.
type Posting struct {
	DocID     string // unique document identifier
	Positions []int  // term positions within the document (for phrase queries later)
}
