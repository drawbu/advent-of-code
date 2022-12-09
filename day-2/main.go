package day_2

import (
	"bufio"
	"main/utils"
	"strconv"
	"strings"
)

type Day2 struct {
}

func (d Day2) PartOne() string {
	var sum int
	file := utils.OpenFile("./day-2/input.txt")
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
	return strconv.Itoa(sum)
}

func (d Day2) PartTwo() string {
	var sum int
	file := utils.OpenFile("./day-2/input.txt")
	defer file.Close()

	values := map[string]int{
		"Rock":     1,
		"Paper":    2,
		"Scissors": 3,
	}
	translateMap := map[string]string{
		"A": "Rock",
		"B": "Paper",
		"C": "Scissors",
	}
	winsOn := map[string]string{
		"Rock":     "Scissors",
		"Paper":    "Rock",
		"Scissors": "Paper",
	}
	loseOn := map[string]string{
		"Rock":     "Paper",
		"Paper":    "Scissors",
		"Scissors": "Rock",
	}
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		objects := strings.Split(scanner.Text(), " ")
		opponent := translateMap[objects[0]]
		objective := objects[1]

		// The player need to lose
		if objective == "X" {
			sum += values[winsOn[opponent]]
			continue
		}

		if objective == "Y" {
			sum += values[opponent] + 3
			continue
		}

		sum += values[loseOn[opponent]] + 6
	}
	return strconv.Itoa(sum)
}
