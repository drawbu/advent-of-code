package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	fmt.Printf(
		"part 1: %v\n",
		totalScore(),
	)
}

func totalScore() (sum int) {
	file := openFile("./day-2/input.txt")
	defer file.Close()

	values := map[string]int{
		"Rock":     1,
		"Paper":    2,
		"Scissors": 3,
	}
	translateMap := map[string]string{
		"X": "Rock",
		"Y": "Paper",
		"Z": "Scissors",
		"A": "Rock",
		"B": "Paper",
		"C": "Scissors",
	}
	winsOn := map[string]string{
		"Rock":     "Scissors",
		"Paper":    "Rock",
		"Scissors": "Paper",
	}
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		objects := strings.Split(scanner.Text(), " ")
		opponent := translateMap[objects[0]]
		player := translateMap[objects[1]]

		// If the player wins
		if winsOn[player] == opponent {
			sum += values[player] + 6
			continue
		}
		// If the opponent wins
		if winsOn[opponent] == player {
			sum += values[player]
			continue
		}
		// Else, it's a draw.
		sum += values[player] + 3
	}
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
