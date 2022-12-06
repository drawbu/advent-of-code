package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	fmt.Printf(
		"part 1: %v\n",
		findStartOfPacketMarker(),
	)
}

func findStartOfPacketMarker() (result int) {
	file := openFile("./day-6/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	if scanner.Scan() {
		text := scanner.Text()
		set := Set{}
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
	items []int32
}

func (d *Set) Add(element int32) bool {
	d.items = append(d.items[len(d.items)/4:], element)
	if len(d.items) < 4 {
		return false
	}
	for i, item := range d.items {
		for _, item2 := range d.items[i+1:] {
			if item == item2 {
				return false
			}
		}
	}
	return true
}
