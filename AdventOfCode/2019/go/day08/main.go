package main

import (
	"bytes"
	"fmt"
	"io"
	"math"
	"os"
)

func main() {
	var width, height = 25, 6
	//var width, height = 2, 2
	var layers [][]int
	buf := bytes.NewBuffer(nil)
	io.Copy(buf, os.Stdin)
	for i, c := range string(buf.Bytes()) {
		var pixel int
		switch c {
		case '0':
			pixel = 0
		case '1':
			pixel = 1
		case '2':
			pixel = 2
		default:
			continue
		}
		l := i / (width * height)
		if l >= len(layers) {
			layers = append(layers, make([]int, 0))
		}
		layers[l] = append(layers[l], pixel)
	}
	var leastZeros, checksum = math.MaxInt32, 0
	for _, l := range layers {
		var counters [3]int
		for _, pixel := range l {
			counters[pixel] += 1
		}
		if counters[0] < leastZeros {
			leastZeros = counters[0]
			checksum = counters[1] * counters[2]
		}
	}
	fmt.Println("Part One", checksum)

	var raster = make([]int, width*height)
	for i, _ := range raster {
		raster[i] = 2
	}
	for z := len(layers) - 1; z >= 0; z-- {
		for i, pixel := range layers[z] {
			if pixel == 1 || pixel == 0 {
				raster[i] = pixel
			}
		}
	}
	for i, pixel := range raster {
		if i%width == 0 {
			fmt.Print("\n")
		}
		switch pixel {
		case 2:
			fmt.Print(" ")
		case 1:
			fmt.Print("#")
		case 0:
			fmt.Print(".")
		}
	}
	fmt.Print("\n")
}
