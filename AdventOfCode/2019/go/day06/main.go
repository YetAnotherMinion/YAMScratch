package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	var duplicates map[string]struct{} = make(map[string]struct{}, 0)
	var inOrbit map[string]bool = make(map[string]bool, 0)
	var orbits map[string][]string = make(map[string][]string, 0)
	var reverseOrbits map[string]string = make(map[string]string, 0)
	for scanner.Scan() {
		s := strings.TrimSpace(scanner.Text())
		items := strings.Split(s, ")")
		if len(items) != 2 {
			continue
		}
		if _, ok := duplicates[s]; ok {
			continue
		}
		duplicates[s] = empty
		parent, child := items[0], items[1]
		inOrbit[child] = true
		orbits[parent] = append(orbits[parent], child)
		reverseOrbits[child] = parent
	}
	// COM is the universal Center of Mass
	fmt.Println("Part One", countNestedOrbits("COM", orbits, 0))
	a := path("YOU", reverseOrbits)
	b := path("SAN", reverseOrbits)
	for {
		if len(a) == 0 || len(b) == 0 || a[len(a)-1] != b[len(b)-1] {
			break
		}
		a = a[:len(a)-1]
		b = b[:len(b)-1]
	}
	fmt.Println("Part Two", len(a)+len(b))
}

var empty struct{}

func countNestedOrbits(parent string, orbits map[string][]string, height int) int {
	var indirectOrbits int = height
	if children, ok := orbits[parent]; ok {
		for _, child := range children {
			indirectOrbits += countNestedOrbits(child, orbits, height+1)
		}
	}
	return indirectOrbits
}

func path(object string, reverseOrbits map[string]string) []string {
	var reversePath []string
	for {
		parent, ok := reverseOrbits[object]
		if !ok {
			break
		}
		reversePath = append(reversePath, parent)
		object = parent
	}
	return reversePath
}
