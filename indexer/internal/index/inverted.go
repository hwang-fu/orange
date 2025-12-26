package index

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
