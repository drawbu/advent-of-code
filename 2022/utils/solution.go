package utils

// Solution is the interface that wraps the partOne and partTwo methods.
// I use this interface to run all the solutions.
// I stole this idea from https://github.com/Capucinoxx/advent-of-code
type Solution interface {
	// PartOne is the solution to the first part of the puzzle
	PartOne() string

	// PartTwo is the solution to the second part of the puzzle
	PartTwo() string
}

func Print(s Solution) (string, string) {
	return s.PartOne(), s.PartTwo()
}
