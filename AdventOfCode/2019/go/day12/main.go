package main

import (
	"fmt"
	"math/big"
)

func main() {
	var history [3]map[state]int = [3]map[state]int{
		make(map[state]int),
		make(map[state]int),
		make(map[state]int),
	}
	// The x, y, z are independent
	var position [3]moons = [3]moons{
		moons{4, 11, -2, -7},
		moons{1, -18, -10, -2},
		moons{1, -1, -4, 14},
	}
	var velocity [3]moons

	// assumes there are no cycles of zero length
	var finishedCycle [3]int
	var cycleLen [3]int64

	for k := 0; k < 3; k++ {
		history[k][state{position[k], velocity[k]}] = 0
	}

	for t := 0; t < 1000000; t++ {
		// update velocity
		for k := 0; k < 3; k++ {
			// consider each pair of moons
			for i := 0; i < 4; i++ {
				for j := i + 1; j < 4; j++ {
					dvi, dvj := delta(position[k][i], position[k][j])
					velocity[k][i] += dvi
					velocity[k][j] += dvj
				}
			}
		}
		// update position
		for k := 0; k < 3; k++ {
			for i := 0; i < 4; i++ {
				position[k][i] += velocity[k][i]
			}
			key := state{position[k], velocity[k]}
			if lastVisited, ok := history[k][key]; ok {
				if finishedCycle[k] == 0 {
					cycleLen[k] = int64(t - lastVisited + 1)
				}
				finishedCycle[k] = t
			} else {
				history[k][key] = t
			}
		}

		var totalEnergy int
		for i := 0; i < 4; i++ {
			totalEnergy += energy(i, position) * energy(i, velocity)
		}

		// uncomment and set the number of ticks to simulate for part one
		// fmt.Println("energy", totalEnergy)
		if finishedCycle[0] != 0 && finishedCycle[1] != 0 && finishedCycle[2] != 0 {
			break
		}
	}
	var x, y, z = big.NewInt(cycleLen[0]), big.NewInt(cycleLen[1]), big.NewInt(cycleLen[2])

	fmt.Println("Part Two:", lcm(z, lcm(x, y)))
}

type moons [4]int
type state struct {
	p moons
	v moons
}

func lcm(a, b *big.Int) *big.Int {
	var out, product, gcd = big.NewInt(0), big.NewInt(0), big.NewInt(0)
	gcd.GCD(nil, nil, a, b)
	product.Mul(a, b)
	return out.Quo(product, gcd)
}

func delta(a, b int) (int, int) {
	if a > b {
		return -1, 1
	} else if a < b {
		return 1, -1
	} else {
		return 0, 0
	}
}

func energy(i int, a [3]moons) int {
	return abs(a[0][i]) + abs(a[1][i]) + abs(a[2][i])
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
