package main

import (
	"fmt"
)

func main() {
	var start, end int = 124075, 580769
	var partOneValid, partTwoValid int
	for password := start; password <= end; password++ {
		var a, b, c, d, e, f int
		s := fmt.Sprintf("%d", password)
		n, err := fmt.Sscanf(s, "%1d%1d%1d%1d%1d%1d", &a, &b, &c, &d, &e, &f)
		if err != nil {
			panic(err)
		}
		if n != 6 {
			panic("expected a six digit number")
		}

		if matchesPartOneClues(a, b, c, d, e, f) {
			partOneValid += 1
			if matchesPartTwoClues(a, b, c, d, e, f) {
				partTwoValid += 1
			}
		}
	}
	fmt.Println("Part One:", partOneValid)
	fmt.Println("Part One:", partTwoValid)
}

func matchesPartOneClues(a, b, c, d, e, f int) bool {
	// assumes the password is a six-digit number
	if a <= b && b <= c && c <= d && d <= e && e <= f {
		if a == b || b == c || c == d || d == e || e == f {
			return true
		}
	}
	return false
}

func matchesPartTwoClues(a, b, c, d, e, f int) bool {
	m0 := prettyMask(1, 1, 0, 0, 0, 0)
	m1 := prettyMask(0, 1, 1, 0, 0, 0)
	m2 := prettyMask(0, 0, 1, 1, 0, 0)
	m3 := prettyMask(0, 0, 0, 1, 1, 0)
	m4 := prettyMask(0, 0, 0, 0, 1, 1)
	var oneValidDoubleRun bool
	for digit := 0; digit <= 9; digit++ {
		digitMask := mask(a == digit, b == digit, c == digit, d == digit, e == digit, f == digit)
		oneValidDoubleRun = any(
			oneValidDoubleRun,
			digitMask == m0,
			digitMask == m1,
			digitMask == m2,
			digitMask == m3,
			digitMask == m4,
		)
	}
	return oneValidDoubleRun
}

func any(args ...bool) bool {
	for _, predicate := range args {
		if predicate {
			return true
		}
	}
	return false
}

func prettyMask(u, v, w, x, y, z int) int {
	return mask(u == 1, v == 1, w == 1, x == 1, y == 1, z == 1)
}

func mask(u, v, w, x, y, z bool) int {
	var output int
	if u {
		output |= 1 << 5
	}
	if v {
		output |= 1 << 4
	}
	if w {
		output |= 1 << 3
	}
	if x {
		output |= 1 << 2
	}
	if y {
		output |= 1 << 1
	}
	if z {
		output |= 1
	}
	return output
}
