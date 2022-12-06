package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	fmt.Printf(
		"part 1: %v\npart 2: %v\n",
		findStartOfPacketMarker(),
		findStartOfMessageMarker(),
	)
}

func findStartOfPacketMarker() (result int) {
	file := openFile("./day-6/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	if scanner.Scan() {
		text := scanner.Text()
		set := Set{size: 4}
		for i, c := range text {
			if set.Add(c) {
				return i + 1
			}
		}
	}
	return -1
}

// Open the input.txt file and return the content.
func openFile(path string) *os.File {
	file, err := os.Open(path)
	if err != nil {
		fmt.Printf("Cannot open file.\n")
		panic(err)
	}
	return file
}

type Set struct {
	size  int
	items []int32
}

func (s *Set) Add(element int32) bool {
	s.items = append(s.items[len(s.items)/s.size:], element)
	if len(s.items) < s.size {
		return false
	}
	for i, item := range s.items {
		for _, item2 := range s.items[i+1:] {
			if item == item2 {
				return false
			}
		}
	}
	return true
}

func findStartOfMessageMarker() (result int) {
	file := openFile("./day-6/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	if scanner.Scan() {
		text := scanner.Text()
		set := Set{size: 14}
		for i, c := range text {
			if set.Add(c) {
				return i + 1
			}
		}
	}
	return -1
}
