package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	fmt.Println(maxCaloriesFinder(3))
}

// Find the sum of the calories of the top three
// Elves carrying the most calories as an integer.
func maxCaloriesFinder(arrayLen int) int {
	file := openFile()
	defer file.Close()

	caloriesSum := 0
	maxCalories := []int{0, 0, 0}
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		x, err := strconv.Atoi(scanner.Text())
		if err != nil {
			if caloriesSum > maxCalories[0] {
				insertValue(&maxCalories, caloriesSum, arrayLen)
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
	return sum
}

// Open the input.txt file and return the content.
func openFile() *os.File {
	file, err := os.Open("./day-1/input.txt")
	if err != nil {
		fmt.Printf("Cannot open file.\n")
		panic(err)
	}
	return file
}

// Insert a value `value` at the index on the
// array `array` on the sorted array of fixed size.
func insertValue(array *[]int, value int, arrayLen int) {
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
