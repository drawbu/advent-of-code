package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	fmt.Printf(
		"part 1: %v\npart 2: %v\n",
		findOverlap(),
		findOverlapV2(),
	)
}

func findOverlap() (result int) {
	file := openFile("./day-4/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		text := strings.Split(scanner.Text(), ",")
		section1 := text[0]
		section2 := text[1]
		if doesThisPairFullyOverlap(section1, section2) {
			result++
		}
	}
	return
}

func doesThisPairFullyOverlap(section1 string, section2 string) bool {
	id1 := getActualId(section1)
	id2 := getActualId(section2)
	if id1[0] <= id2[0] && id1[1] >= id2[1] {
		return true
	}
	if id2[0] <= id1[0] && id2[1] >= id1[1] {
		return true
	}
	return false
}

func getActualId(section string) [2]int {
	id := strings.Split(section, "-")
	digit1, _ := strconv.Atoi(id[0])
	digit2, _ := strconv.Atoi(id[1])
	return [2]int{digit1, digit2}
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

func findOverlapV2() (result int) {
	file := openFile("./day-4/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		text := strings.Split(scanner.Text(), ",")
		section1 := text[0]
		section2 := text[1]
		if doesThisPairOverlapAtAll(section1, section2) {
			result++
		}
	}
	return
}

func doesThisPairOverlapAtAll(section1 string, section2 string) bool {
	id1 := getActualId(section1)
	id2 := getActualId(section2)
	if id2[0] >= id1[0] && id2[0] <= id1[1] {
		return true
	}
	if id1[0] >= id2[0] && id1[0] <= id2[1] {
		return true
	}
	if id2[1] >= id1[0] && id2[1] <= id1[1] {
		return true
	}
	if id1[1] >= id2[0] && id1[1] <= id2[1] {
		return true
	}
	return false
}
