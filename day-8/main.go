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
	result += trees.size[0]*2 + trees.size[1]*2 - 4

	for trees.scan(1) {
		x, y := trees.current()

		// right
		visible := true
		for i := y + 1; i < trees.size[1]; i++ {
			if trees.get(x, i) >= trees.get(x, y) {
				visible = false
				break
			}
		}
		if visible {
			result++
			continue
		}

		// left
		visible = true
		for i := y - 1; i >= 0; i-- {
			if trees.get(x, i) >= trees.get(x, y) {
				visible = false
				break
			}
		}
		if visible {
			result++
			continue
		}

		// up
		visible = true
		for i := x - 1; i >= 0; i-- {
			if trees.get(i, y) >= trees.get(x, y) {
				visible = false
				break
			}
		}
		if visible {
			result++
			continue
		}

		// down
		visible = true
		for i := x + 1; i < trees.size[0]; i++ {
			if trees.get(i, y) >= trees.get(x, y) {
				visible = false
				break
			}
		}
		if visible {
			result++
			continue
		}
	}
	return
}

// Part 2: find the best location to see the most trees.
func partTwo() (result int) {
	trees := getTreeList(*openFile("./day-8/input.txt"))
	bestTree := [2]int{0, 0}

	for trees.scan(0) {
		x, y := trees.current()

		scenicScore := 1
		// right
		s := 0
		for i := y + 1; i < trees.size[1]; i++ {
			s++
			if trees.get(x, i) >= trees.get(x, y) {
				break
			}
		}
		scenicScore *= s
		// left
		s = 0
		for i := y - 1; i >= 0; i-- {
			s++
			if trees.get(x, i) >= trees.get(x, y) {
				break
			}
		}
		scenicScore *= s
		// up
		s = 0
		for i := x - 1; i >= 0; i-- {
			s++
			if trees.get(i, y) >= trees.get(x, y) {
				break
			}
		}
		scenicScore *= s
		// down
		s = 0
		for i := x + 1; i < trees.size[0]; i++ {
			s++
			if trees.get(i, y) >= trees.get(x, y) {
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
func getTreeList(file os.File) Trees {
	defer file.Close()

	var trees [][]int32
	scanner := bufio.NewScanner(&file)
	for scanner.Scan() {
		text := scanner.Text()
		var row []int32
		for _, t := range text {
			row = append(row, t)
		}
		trees = append(trees, row)
	}
	return Trees{trees, 0, 0, [2]int{len(trees), len(trees[0])}}
}

type Trees struct {
	list [][]int32
	x    int
	y    int
	size [2]int
}

func (t *Trees) get(x int, y int) int32 {
	return t.list[x][y]
}

func (t *Trees) scan(bordersSize int) bool {
	if t.x == 0 {
		t.x = bordersSize
	}
	if t.x == t.size[0]-1-bordersSize && t.y == t.size[1]-1-bordersSize {
		return false
	}
	if t.y == t.size[1]-1-bordersSize {
		t.x++
		t.y = bordersSize
	} else {
		t.y++
	}
	return true
}

func (t *Trees) current() (int, int) {
	return t.x, t.y
}
