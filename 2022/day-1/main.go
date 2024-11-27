package day_1

import (
	"bufio"
	"aoc2022/utils"
	"strconv"
)

type Day1 struct {
}

func (d Day1) PartOne() string {
	return "Oops, I removed this part."
}

// Find the sum of the calories of the top three
// Elves carrying the most calories as an integer.
func (d Day1) PartTwo() string {
	file := utils.OpenFile("./day-1/input.txt")
	defer file.Close()

	caloriesSum := 0
	maxCalories := []int{0, 0, 0}
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		x, err := strconv.Atoi(scanner.Text())
		if err != nil {
			if caloriesSum > maxCalories[0] {
				insertValue(&maxCalories, caloriesSum)
			}
			caloriesSum = 0
			continue
		}
		caloriesSum += x
	}
	var sum int
	for _, x := range maxCalories {
		sum += x
	}
	return strconv.Itoa(sum)
}

// Insert a value `value` at the index on the
// array `array` on the sorted array of fixed size.
func insertValue(array *[]int, value int) {
	var i int
	for i = 0; i < len(*array); i++ {
		if value < (*array)[i] {
			break
		}
	}

	for j := 0; j+1 < i; j++ {
		(*array)[j] = (*array)[j+1]
	}
	(*array)[i-1] = value
	return
}
