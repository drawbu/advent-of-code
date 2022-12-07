package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	fmt.Printf(
		"part 1: %v\n",
		sumSizeSmallDirectories(),
	)
}

func sumSizeSmallDirectories() (result int) {
	fs := getFileSystem(*openFile("./day-7/input.txt"))

	for _, size := range fs {
		if size <= 100000 {
			result += size
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
