package main

import (
	"aoc2022/day-1"
	"aoc2022/day-2"
	"aoc2022/day-3"
	"aoc2022/day-4"
	"aoc2022/day-5"
	"aoc2022/day-6"
	"aoc2022/day-7"
	"aoc2022/day-8"
	"aoc2022/day-9"
	"aoc2022/utils"
	"fmt"
)

func main() {
	sol := []utils.Solution{
		&day_1.Day1{},
		&day_2.Day2{},
		&day_3.Day3{},
		&day_4.Day4{},
		&day_5.Day5{},
		&day_6.Day6{},
		&day_7.Day7{},
		&day_8.Day8{},
		&day_9.Day9{},
	}
	for i, s := range sol {
		partOne, partTwo := utils.Print(s)
		fmt.Printf(
			"Day %v:\n part 1: %v\n part 2: %v\n\n",
			i+1, partOne, partTwo,
		)
	}
}
