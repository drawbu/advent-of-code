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
		"part 1: %v\n",
		moveCrates(),
	)
}

func moveCrates() (result string) {
	file := openFile("./day-5/input.txt")
	defer file.Close()

	instructions := false
	scanner := bufio.NewScanner(file)
	var defaultStacks []string
	var stacks []Stack
	for scanner.Scan() {
		text := scanner.Text()

		// Get starting crates position
		if !instructions {
			if text == "" {
				instructions = true
				stacks = splitter(defaultStacks)
				continue
			}
			defaultStacks = append(defaultStacks, text)
			continue
		}

		// Applies instructions
		movement := getMovement(text)
		for i := 0; i < movement[0]; i++ {
			element := stacks[movement[1]-1].Pop()
			stacks[movement[2]-1].Add(element)
		}
	}

	// Get last letter of each
	for _, s := range stacks {
		result += s.items[len(s.items)-1]
	}
	return
}

func splitter(crates []string) (stacks []Stack) {
	// Create the stacks for the crates
	letters := strings.Split(crates[len(crates)-1], " ")
	letter, err := strconv.Atoi(letters[len(letters)-1])
	if err != nil {
		panic(err)
	}
	for i := 0; i < letter; i++ {
		stacks = append(stacks, Stack{})
	}

	// Sort the crates in the Stacks
	for i := range crates[:len(crates)-1] {
		index := len(crates) - 2 - i
		crates[index] += " "
		for j := 0; j < len(crates[index])/4; j++ {
			crate := string(crates[index][j*4+1])
			if crate == " " || crate == "" {
				continue
			}
			stacks[j].Add(crate)
		}
	}
	return
}

type Stack struct {
	items []string
}

func (d *Stack) Add(element string) {
	d.items = append(d.items, element)
}

func (d *Stack) Pop() (element string) {
	element = d.items[len(d.items)-1]
	d.items = d.items[:len(d.items)-1]
	return
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

func getMovement(text string) [3]int {
	move, err := strconv.Atoi(strings.Replace(text[5:7], " ", "", 1))
	if err != nil {
		panic(err)
	}
	from, err := strconv.Atoi(strings.Replace(text[12:14], " ", "", 1))
	if err != nil {
		panic(err)
	}
	to, err := strconv.Atoi(strings.Replace(text[17:], " ", "", 1))
	if err != nil {
		panic(err)
	}
	return [3]int{move, from, to}
}
