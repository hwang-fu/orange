.PHONY: all build check fmt clean test

BINARY := pumpkin

all: check build

build:
	go build -o $(BINARY) ./cmd/pumpkin

check:
	go vet ./...

fmt:
	gofmt -w .

clean:
	rm -f $(BINARY)

test:
	go test ./...
