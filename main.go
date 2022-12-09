package main

import (
	"fmt"
	"main/day-1"
	"main/day-2"
	"main/day-3"
	"main/day-4"
	"main/day-5"
	"main/day-6"
	"main/day-7"
	"main/day-8"
	"main/utils"
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
	}
	for i, s := range sol {
		partOne, partTwo := utils.Print(s)
		fmt.Printf(
			"Day %v:\n part 1: %v\n part 2: %v\n\n",
			i+1, partOne, partTwo,
		)
	}
}
