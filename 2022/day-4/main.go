package day_4

import (
	"bufio"
	"aoc2022/utils"
	"strconv"
	"strings"
)

type Day4 struct {
}

func (d Day4) PartOne() string {
	var result int
	file := utils.OpenFile("./day-4/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		text := strings.Split(scanner.Text(), ",")
		section1 := text[0]
		section2 := text[1]
		if doesThisPairFullyOverlap(section1, section2) {
			result++
		}
	}
	return strconv.Itoa(result)
}

func (d Day4) PartTwo() string {
	var result int
	file := utils.OpenFile("./day-4/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		text := strings.Split(scanner.Text(), ",")
		section1 := text[0]
		section2 := text[1]
		if doesThisPairOverlapAtAll(section1, section2) {
			result++
		}
	}
	return strconv.Itoa(result)
}

func doesThisPairFullyOverlap(section1 string, section2 string) bool {
	id1 := getActualId(section1)
	id2 := getActualId(section2)
	if id1[0] <= id2[0] && id1[1] >= id2[1] {
		return true
	}
	if id2[0] <= id1[0] && id2[1] >= id1[1] {
		return true
	}
	return false
}

func getActualId(section string) [2]int {
	id := strings.Split(section, "-")
	digit1, _ := strconv.Atoi(id[0])
	digit2, _ := strconv.Atoi(id[1])
	return [2]int{digit1, digit2}
}

func doesThisPairOverlapAtAll(section1 string, section2 string) bool {
	id1 := getActualId(section1)
	id2 := getActualId(section2)
	if id2[0] >= id1[0] && id2[0] <= id1[1] {
		return true
	}
	if id1[0] >= id2[0] && id1[0] <= id2[1] {
		return true
	}
	if id2[1] >= id1[0] && id2[1] <= id1[1] {
		return true
	}
	if id1[1] >= id2[0] && id1[1] <= id2[1] {
		return true
	}
	return false
}
