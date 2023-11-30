package day_9

import (
	"bufio"
	"fmt"
	"main/utils"
	"math"
	"strconv"
	"strings"
)

type Day9 struct {
}

// PartOne : get the number of different positions visited by the tail
func (d Day9) PartOne() string {
	file := utils.OpenFile("./day-9/input.txt")
	defer file.Close()

	rope := Rope{make([]Point, 2)}
	positions := Positions{}

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		text := strings.Split(scanner.Text(), " ")
		quantity, err := strconv.Atoi(text[1])
		if err != nil {
			panic(err)
		}
		for i := 0; i < quantity; i++ {
			rope.points[0].Move(text[0])
			rope.points[1].Follow(rope.points[0])
			positions.Add(fmt.Sprintf("%d,%d", rope.points[1].x, rope.points[1].y))
		}
	}
	return strconv.Itoa(len(positions.list))
}

// PartTwo :
func (d Day9) PartTwo() string {
	return "Not implemented"
}

type Rope struct {
	points []Point
}

type Point struct {
	x int
	y int
}

func (p *Point) Move(direction string) {
	switch direction {
	case "U":
		p.y++
	case "D":
		p.y--
	case "L":
		p.x--
	case "R":
		p.x++
	}
}

func (p *Point) Follow(parent Point) {
	// left
	if parent.x-p.x >= 2 {
		if math.Abs(float64(parent.y-p.y)) == 1 {
			p.y = parent.y
		}
		p.x++
	}

	// right
	if parent.x-p.x <= -2 {
		if math.Abs(float64(parent.y-p.y)) == 1 {
			p.y = parent.y
		}
		p.x--
	}

	// up
	if parent.y-p.y >= 2 {
		if math.Abs(float64(parent.x-p.x)) == 1 {
			p.x = parent.x
		}
		p.y++
	}

	// down
	if parent.y-p.y <= -2 {
		if math.Abs(float64(parent.x-p.x)) == 1 {
			p.x = parent.x
		}
		p.y--
	}
}

type Positions struct {
	list []string
}

func (p *Positions) Add(position string) {
	for _, v := range p.list {
		if v == position {
			return
		}
	}
	p.list = append(p.list, position)
}
