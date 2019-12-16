package main

import (
	"bytes"
	"fmt"
	"io"
	"math"
	"os"
	"strings"
)

func main() {
	var rules = make(map[string]rule)
	buf := bytes.NewBuffer(nil)
	io.Copy(buf, os.Stdin)
	for _, line := range strings.Split(string(buf.Bytes()), "\n") {
		parts := strings.Split(line, " => ")
		if len(parts) != 2 {
			continue
		}
		var r rule
		r.output = parseIngredient(parts[1])
		for _, raw := range strings.Split(parts[0], ",") {
			r.inputs = append(r.inputs, parseIngredient(strings.TrimSpace(raw)))
		}
		rules[r.output.name] = r
		if _, ok := rules[r.output.name]; !ok {
			panic("expected only one way to make each chemical")
		}
	}
	var inventory = make(map[string]int64)
	// Give it a lot of ore for the initial run
	inventory["ORE"] = 1000 * 1000 * 1000 * 1000
	var costs = make(map[string]int64)

	var result = canMake(1, "FUEL", rules, inventory, costs)
	fmt.Println("Part One", result, costs["ORE"])
	fmt.Println("costs", costs)
	fmt.Println("inventory", inventory)

	// binary search
	var low, high int64 = 0, math.MaxInt64
	for low <= high {
		var mid int64 = (high-low)/2 + low
		inventory = make(map[string]int64)
		inventory["ORE"] = 1000 * 1000 * 1000 * 1000
		costs = make(map[string]int64)
		var result = canMake(mid, "FUEL", rules, inventory, costs)
		if result {
			fmt.Println("too low", mid)
			low = mid + 1
		} else if !result {
			fmt.Println("too high", mid)
			high = mid - 1
		}
	}
}

func canMake(target int64, name string, rules map[string]rule, inventory, costs map[string]int64) bool {
	var rule, ok = rules[name]
	if !ok {
		panic("rule should exist")
	}
	var scalar = target / rule.output.count
	if target%rule.output.count != 0 {
		scalar += 1
	}

	for _, input := range rule.inputs {
		for {
			if inventory[input.name] < input.count*scalar {
				// special case the base input because it cannot be created
				if input.name == "ORE" {
					return false
				}
				if !canMake(scalar*input.count, input.name, rules, inventory, costs) {
					return false
				}
			} else {
				// use the inventory to contribute to making more of the current target
				if input.name == "ORE" {
					costs["ORE"] += input.count * scalar
				}
				inventory[input.name] -= input.count * scalar
				break
			}
		}
	}
	inventory[name] += rule.output.count * scalar
	costs[name] += rule.output.count * scalar
	return true
}

func parseIngredient(raw string) ingredient {
	var output ingredient
	n, err := fmt.Sscanf(raw, "%d %s", &output.count, &output.name)
	if err != nil {
		panic(err)
	}
	if n != 2 {
		panic("expected count and name")
	}
	return output
}

type rule struct {
	inputs []ingredient
	output ingredient
}

type ingredient struct {
	name  string
	count int64
}
