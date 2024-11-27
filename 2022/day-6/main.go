package day_6

import (
	"bufio"
	"aoc2022/utils"
	"strconv"
)

type Day6 struct {
}

// Part 1: find the start of the packet marker.
func (d Day6) PartOne() string {
	return strconv.Itoa(findStartOfMarker(4))
}

// Part 2: find the start of the Message marker.
func (d Day6) PartTwo() string {
	return strconv.Itoa(findStartOfMarker(14))
}

// Find start of a marker of a given size in the input.txt file.
func findStartOfMarker(size int) (result int) {
	file := utils.OpenFile("./day-6/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	if scanner.Scan() {
		text := scanner.Text()
		set := Set{size: size}
		for i, c := range text {
			if set.Add(c) {
				return i + 1
			}
		}
	}
	return -1
}

type Set struct {
	size  int
	items []int32
}

func (s *Set) Add(element int32) bool {
	s.items = append(s.items[len(s.items)/s.size:], element)
	if len(s.items) < s.size {
		return false
	}
	for i, item := range s.items {
		for _, item2 := range s.items[i+1:] {
			if item == item2 {
				return false
			}
		}
	}
	return true
}
