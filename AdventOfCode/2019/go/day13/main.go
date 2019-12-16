package main

import (
	"fmt"
    "time"
)

const animationSpeed = 300 * time.Millisecond

func main() {
    var image = LoadProgram()
    var vm = image.clone()
	for c := 0; c < 1000000 && !vm.Halt; c++ {
		vm.Step()
    }
    var screen map[point]int = make(map[point]int, 0) 
    for i := 0; i < len(vm.Outputs); i += 3 {
        var x = vm.Outputs[i + 0]
        var y = vm.Outputs[i + 1]
        var tile = vm.Outputs[i + 2]
        screen[point{x,y}] = tile
    }
    var blockTiles int
    for _, v := range screen {
        if v == 2 {
            blockTiles += 1
        }
    }
    fmt.Println("Part One", blockTiles)

    vm = image.clone()
    vm.memory[0] = 2
    var score int
    screen = make(map[point]int)
	for c := 0; c < 1000000 && !vm.Halt; c++ {
		vm.Step()
        // read the outputs onto the screen
        if len(vm.Outputs) % 3 == 0 {
            for i := 0; i < len(vm.Outputs); i += 3 {
                var x = vm.Outputs[i + 0]
                var y = vm.Outputs[i + 1]
                var tile = vm.Outputs[i + 2]
                if x == -1 && y == 0 {
                    score = tile
                } else {
                    screen[point{x,y}] = tile
                }
            }
            vm.Outputs = vm.Outputs[0:0]
        }
        if vm.WaitForInput {
            fmt.Println(score)
            printScreen(screen, score)
            vm.Inputs = append(vm.Inputs, 0)
        }
    }
    fmt.Println("Part Two", score)
}

type point struct {
    x,y int
}

func printScreen(screen map[point]int, score int) {
    fmt.Print("\033[H\033[2J")
    fmt.Println(score)
    var minX, minY, maxX, maxY int
    for k, _ := range screen {
        minX, minY = min(minX, k.x), min(minY, k.y)
        maxX, maxY = max(maxX, k.x), max(maxY, k.y)
    }
    for y := minY; y <= maxY; y++ {
        for x := minX; x <= maxX; x++ {
            switch screen[point{x, y}] {
                case 0:
                    fmt.Print(" ")
                case 1:
                    fmt.Print("#")
                case 2:
                    fmt.Print("B")
                case 3:
                    fmt.Print("=")
                case 4:
                    fmt.Print("0")
            }
        }
        fmt.Print("\n")
    }
    fmt.Print("\n")
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
