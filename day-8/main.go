package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	fmt.Printf(
		"part 1: %v\n",
		partOne(),
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
