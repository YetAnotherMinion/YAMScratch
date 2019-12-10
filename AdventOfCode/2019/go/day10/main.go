package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"sort"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	var asteroids []point = make([]point, 0)
	var y int
	for scanner.Scan() {
		for x, c := range scanner.Text() {
			if c == '#' {
				asteroids = append(asteroids, point{x, y})
			}
		}
		y += 1
	}
	visible, station, sightings := partOne(asteroids)
	fmt.Println("Part One:", visible, station)
	// Part two
	for i, _ := range sightings {
		s := sightings[i]
		s.asteroid.x -= station.x
		s.asteroid.y -= station.y
		sightings[i] = s
	}
	sort.Sort(byDestructionOrder(sightings))
	// assign a destruction order for collinear points
	var prevKey uint64 = math.MaxUint64
	var prevGeneration int
	for i, s := range sightings {
		if s.key == prevKey {
			prevGeneration += 1
			s.generation = prevGeneration
		} else {
			prevKey = s.key
			prevGeneration = 0
		}
		sightings[i] = s
	}
	// Now that we have assigned destruction order for collinear points sort again
	sort.Sort(byDestructionOrder(sightings))
	asteroid := sightings[199].asteroid
	x, y := asteroid.x+station.x, asteroid.y+station.y
	fmt.Println("The 200th asteroid to be vaporized is at", x, ",", y)
	fmt.Println(x*100 + y)
}

func partOne(asteroids []point) (int, point, []sighting) {
	var bestVisible int
	var bestLocation point
	var bestSightings []sighting
	for i, station := range asteroids {
		var slopes map[uint64]bool = make(map[uint64]bool, 0)
		var sightings []sighting = make([]sighting, 0)
		var visible int
		for j, asteroid := range asteroids {
			if i == j {
				continue
			}
			dx := station.x - asteroid.x
			dy := station.y - asteroid.y
			theta := math.Atan2(float64(dy), float64(dx))
			// start measuring angles using the positive y-axis
			theta -= math.Pi / 2
			if theta < 0 {
				theta += 2 * math.Pi
			}

			key := uint64(theta * 1e10)

			sightings = append(sightings, sighting{asteroid, key, 0})

			if _, ok := slopes[key]; !ok {
				slopes[key] = true
				visible += 1
			}
		}
		if visible > bestVisible {
			bestVisible = visible
			bestLocation = station
			bestSightings = sightings
		}
	}
	return bestVisible, bestLocation, bestSightings
}

type point struct {
	x, y int
}

type sighting struct {
	asteroid   point
	key        uint64
	generation int
}

type byDestructionOrder []sighting

func (s byDestructionOrder) Len() int {
	return len(s)
}

func (s byDestructionOrder) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func (s byDestructionOrder) Less(i, j int) bool {
	if s[i].generation == s[j].generation {
		if s[i].key == s[j].key {
			// because points with the same key are colliner, we can use
			// manhattan distance as distance metric to figure out which point
			// is closer to the origin
			return (abs(s[i].asteroid.x) + abs(s[i].asteroid.y)) <
				(abs(s[j].asteroid.x) + abs(s[j].asteroid.y))
		}
		return s[i].key < s[j].key
	}
	return s[i].generation < s[j].generation
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
