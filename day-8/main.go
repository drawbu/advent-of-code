package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	fmt.Printf(
		"part 1: %v\npart 2: %v\n",
		partOne(),
		partTwo(),
	)
}

// Part 1: find the number of trees visible from the borders.
func partOne() (result int) {
	trees := getTreeList(*openFile("./day-8/input.txt"))
	size := [2]int{len(trees), len(trees[0])}
	result += size[0]*2 + size[1]*2 - 4

	for x := 1; x < size[0]-1; x++ {
		for y := 1; y < size[1]-1; y++ {
			visible := true
			// right
			for i := y + 1; i < size[1]; i++ {
				if trees[x][i] >= trees[x][y] {
					visible = false
					break
				}
			}
			if visible {
				result++
				continue
			}
			visible = true
			// left
			for i := y - 1; i >= 0; i-- {
				if trees[x][i] >= trees[x][y] {
					visible = false
					break
				}
			}
			if visible {
				result++
				continue
			}
			visible = true
			// up
			for i := x - 1; i >= 0; i-- {
				if trees[i][y] >= trees[x][y] {
					visible = false
					break
				}
			}
			if visible {
				result++
				continue
			}
			visible = true
			// down
			for i := x + 1; i < size[0]; i++ {
				if trees[i][y] >= trees[x][y] {
					visible = false
					break
				}
			}
			if visible {
				result++
				continue
			}
		}
	}
	return
}

// Part 2: find the best location to see the most trees.
func partTwo() (result int) {
	trees := getTreeList(*openFile("./day-8/input.txt"))
	size := [2]int{len(trees), len(trees[0])}

	bestTree := [2]int{0, 0}

	for x := 0; x < size[0]; x++ {
		for y := 0; y < size[1]; y++ {
			scenicScore := 1
			// right
			s := 0
			for i := y + 1; i < size[1]; i++ {
				s++
				if trees[x][i] >= trees[x][y] {
					break
				}
			}
			scenicScore *= s
			// left
			s = 0
			for i := y - 1; i >= 0; i-- {
				s++
				if trees[x][i] >= trees[x][y] {
					break
				}
			}
			scenicScore *= s
			// up
			s = 0
			for i := x - 1; i >= 0; i-- {
				s++
				if trees[i][y] >= trees[x][y] {
					break
				}
			}
			scenicScore *= s
			// down
			s = 0
			for i := x + 1; i < size[0]; i++ {
				s++
				if trees[i][y] >= trees[x][y] {
					break
				}
			}
			scenicScore *= s

			if scenicScore > result {
				result = scenicScore
				bestTree[0] = x
				bestTree[1] = y
			}
		}
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

// Get the file system as a map of path -> size.
func getTreeList(file os.File) (trees [][]int32) {
	defer file.Close()

	scanner := bufio.NewScanner(&file)
	for scanner.Scan() {
		text := scanner.Text()
		var row []int32
		for _, t := range text {
			row = append(row, t)
		}
		trees = append(trees, row)
	}
	return
}
