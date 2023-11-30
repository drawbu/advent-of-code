package day_3

import (
	"bufio"
	"fmt"
	"main/utils"
	"strconv"
	"strings"
)

type Day3 struct {
}

func (d Day3) PartOne() string {
	var sum int
	file := utils.OpenFile("./day-3/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		text := scanner.Text()
		e, err := findElements(text)
		if err != nil {
			panic(err)
		}
		sum += whatsThePriority(e)
	}
	return strconv.Itoa(sum)
}

func (d Day3) PartTwo() string {
	var sum int
	file := utils.OpenFile("./day-3/input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		var group []string
		group = append(group, scanner.Text())
		scanner.Scan()
		group = append(group, scanner.Text())
		scanner.Scan()
		group = append(group, scanner.Text())

		e, err := gimmeTheBadge(group)
		if err != nil {
			panic(err)
		}
		sum += whatsThePriority(e)
	}
	return strconv.Itoa(sum)
}

func findElements(text string) (element int32, err error) {
	compartment1 := text[:len(text)/2]
	compartment2 := text[len(text)/2:]
	for _, e := range compartment1 {
		for _, k := range compartment2 {
			if e == k {
				return e, nil
			}
		}
	}
	err = fmt.Errorf(
		"cannot find a recurrent element on each compartment on the "+
			"following string:\n    \"%v\"",
		text,
	)
	return 0, err
}

func whatsThePriority(element int32) int {
	if strings.ToLower(string(element)) == string(element) {
		return int(element) - 96
	}
	return int(element) - 64 + 26
}

func gimmeTheBadge(group []string) (badge int32, err error) {
	for _, e := range group[0] {
		for _, k := range group[1] {
			if string(e) != string(k) {
				continue
			}
			for _, l := range group[2] {
				if string(e) == string(l) {
					return e, nil
				}
			}
		}
	}
	err = fmt.Errorf(
		"cannot find a recurrent element on each rucksack of the "+
			"following group:\n    \"%v\"",
		group,
	)
	return 0, err
}
