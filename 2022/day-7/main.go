package day_7

import (
	"bufio"
	"main/utils"
	"os"
	"strconv"
	"strings"
)

type Day7 struct {
}

// Part 1: get the sum of the size of directories with a size < 100_000.
func (d Day7) PartOne() string {
	fs := getFileSystem(*utils.OpenFile("day-7/input.txt"))

	var result int
	for _, size := range fs {
		if size <= 100000 {
			result += size
		}
	}
	return strconv.Itoa(result)
}

// Part 2: find the best directory to remove to have a total size < 40_000_000.
func (d Day7) PartTwo() string {
	fs := getFileSystem(*utils.OpenFile("day-7/input.txt"))

	bestDir := "/"
	freeSpaceNeeded := fs["/"] - 40_000_000
	for path, size := range fs {
		if size >= freeSpaceNeeded {
			if size < fs[bestDir] {
				bestDir = path
			}
		}
	}
	return strconv.Itoa(fs[bestDir])
}

// Get the file system as a map of path -> size.
func getFileSystem(file os.File) map[string]int {
	defer file.Close()

	scanner := bufio.NewScanner(&file)
	fs := make(map[string]int)
	var path []string
	for scanner.Scan() {
		text := strings.Split(scanner.Text(), " ")

		if text[1] == "ls" || text[0] == "dir" {
			continue
		}

		if text[1] == "cd" {
			if text[2] == ".." {
				path = path[:len(path)-1]
				continue
			}
			path = append(path, text[2])
			continue
		}

		fileSize, _ := strconv.Atoi(text[0])
		for i := range path {
			dir := strings.Join(path[:i+1], "/")
			fs[dir] += fileSize
		}
	}
	return fs
}
