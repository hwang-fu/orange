.PHONY: all build check fmt clean test

BINARY := orange

all: check build

build:
	go build -o $(BINARY) ./cmd/orange

check:
	go vet ./...

fmt:
	gofmt -w .

clean:
	rm -f $(BINARY)

test:
	go test ./...
