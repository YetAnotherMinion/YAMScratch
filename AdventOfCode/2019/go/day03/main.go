package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	var grid map[point]int = make(map[point]int, 0)
	var firstLine bool = true
	var closestIntersection, shortestIntersection int = math.MaxInt32, math.MaxInt32
	for scanner.Scan() {
		var location point
		var wireLength int
		for _, segment := range strings.Split(scanner.Text(), ",") {
			distance, err := strconv.Atoi(segment[1:])
			if err != nil {
				panic(err)
			}
			for i := 0; i < distance; i++ {
				wireLength += 1
				switch segment[0] {
				case 'R':
					location.x += 1
				case 'L':
					location.x -= 1
				case 'U':
					location.y += 1
				case 'D':
					location.y -= 1
				}
				if firstWireLength, ok := grid[location]; ok && !firstLine {
					d := manhattanDistance(location)
					if d < closestIntersection {
						closestIntersection = d
					}
					totalWireLength := firstWireLength + wireLength
					if totalWireLength < shortestIntersection {
						shortestIntersection = totalWireLength
					}
				}
				grid[location] = wireLength
			}
		}
		if !firstLine {
			break
		}
		firstLine = false
	}
	fmt.Println("Part One", closestIntersection)
	fmt.Println("Part Two", shortestIntersection)
}

type point struct {
	x, y int
}

func manhattanDistance(p point) int {
	return abs(p.x) + abs(p.y)
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
