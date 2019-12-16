package main

import (
	"bytes"
	"fmt"
	"io"
	"os"
)

func main() {
	var input []int
	buf := bytes.NewBuffer(nil)
	io.Copy(buf, os.Stdin)
	for _, v := range string(buf.Bytes()) {
		if v < '0' || v > '9' {
			continue
		}
		x := int(v - '0')
		input = append(input, x)
	}
	var offset int
	offset += 1000000 * input[0]
	offset += 100000 * input[1]
	offset += 10000 * input[2]
	offset += 1000 * input[3]
	offset += 100 * input[4]
	offset += 10 * input[5]
	offset += 1 * input[6]

	input = repeat(input, 10000)

	var prefixSum = make([]int, len(input)+1)
	for phase := 0; phase < 100; phase++ {
		var previousSum int
		for i, v := range input {
			prefixSum[i+1] = previousSum + v
			previousSum = prefixSum[i+1]
		}

		for i, _ := range input {
			// Event with an input 6500k items long, we should not exceed a sum
			// of 650 million even if every position ends up summing to 81
			var acc int
			acc += genRange(input, prefixSum, 1, i+1)
			acc -= genRange(input, prefixSum, 3, i+1)
			input[i] = truncate(acc)
		}
	}
	fmt.Println(input[offset : offset+8])
}

func truncate(x int) int {
	// return just the ones digit without sign
	return abs(x) % 10
}

func genRange(input, prefixSum []int, target, stride int) int {

	var start = -1
	var acc int
	for group := 0; ; group++ {
		if group%4 == target {
			var end = min(len(input), start+stride)
			acc += prefixSum[end] - prefixSum[start]
		}
		start += stride
		if start >= len(input) {
			return acc
		}
	}
	panic("should terminate")
}

func sum(slice []int) int {
	var acc int
	for _, v := range slice {
		acc += v
	}
	return acc
}

func repeat(input []int, k int) []int {
	var output []int = make([]int, k*len(input))
	for i := 0; i < k; i++ {
		for j, v := range input {
			output[i*len(input)+j] = v
		}
	}
	return output
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
