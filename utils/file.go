package utils

import (
	"fmt"
	"os"
)

// OpenFile open the input file and return the content.
func OpenFile(fileName string) *os.File {
	file, err := os.Open(fileName)
	if err != nil {
		fmt.Printf("Cannot open file.\n")
		panic(err)
	}
	return file
}
