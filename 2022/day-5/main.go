package day_5

import (
	"bufio"
	"aoc2022/utils"
	"strconv"
	"strings"
)

type Day5 struct {
}

// Part 1: Move the crates to the correct stack with a
// CrateMover 9000 and return the last letter of each stack.
func (d Day5) PartOne() string {
	file := utils.OpenFile("./day-5/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	crates := createCrates(getCratesText(scanner))
	for scanner.Scan() {
		mov := getMovement(scanner.Text())
		for i := 0; i < mov[0]; i++ {
			crates[mov[2]-1].Add(crates[mov[1]-1].Pop())
		}
	}
	return getLastLetters(crates)
}

// Part 2: Move the crates to the correct stack with a
// CrateMover 9001 and return the last letter of each stack.
func (d Day5) PartTwo() string {
	file := utils.OpenFile("./day-5/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	crates := createCrates(getCratesText(scanner))
	for scanner.Scan() {
		mov := getMovement(scanner.Text())
		crates[mov[2]-1].MultiAdd(crates[mov[1]-1].MultiPop(mov[0]))
	}
	return getLastLetters(crates)
}

// Get the crates text from the start of the input.txt file.
func getCratesText(scanner *bufio.Scanner) (stacksText []string) {
	for scanner.Scan() {
		text := scanner.Text()
		if text == "" {
			return
		}
		stacksText = append(stacksText, text)
	}
	return
}

// Convert the crates text to a slice of stacks.
func createCrates(cratesText []string) (crates []Stack) {
	// Create the crates for the cratesText
	letters := strings.Split(cratesText[len(cratesText)-1], " ")
	letter, err := strconv.Atoi(letters[len(letters)-1])
	if err != nil {
		panic(err)
	}
	for i := 0; i < letter; i++ {
		crates = append(crates, Stack{})
	}

	// Sort the cratesText in the Stacks
	for i := range cratesText[:len(cratesText)-1] {
		index := len(cratesText) - 2 - i
		cratesText[index] += " "
		for j := 0; j < len(cratesText[index])/4; j++ {
			crate := string(cratesText[index][j*4+1])
			if crate == " " || crate == "" {
				continue
			}
			crates[j].Add(crate)
		}
	}
	return
}

// Get the movement as a slice of int from a text.
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

// Get the last letter of each stack.
func getLastLetters(crates []Stack) (result string) {
	for _, s := range crates {
		result += s.items[len(s.items)-1]
	}
	return
}

// Stack is a stack of strings.
// You can add and remove elements only from the top.
type Stack struct {
	items []string
}

// Add an element to the top of the stack.
func (d *Stack) Add(element string) {
	d.items = append(d.items, element)
}

// Pop an element from the top of the stack and return it.
func (d *Stack) Pop() (element string) {
	element = d.items[len(d.items)-1]
	d.items = d.items[:len(d.items)-1]
	return
}

// MultiAdd adds multiple elements to the top of the stack.
func (d *Stack) MultiAdd(elements []string) {
	d.items = append(d.items, elements...)
}

// MultiPop removes multiple elements from the top of the stack and return them.
func (d *Stack) MultiPop(number int) (elements []string) {
	elements = d.items[len(d.items)-number : len(d.items)]
	d.items = d.items[:len(d.items)-number]
	return
}
