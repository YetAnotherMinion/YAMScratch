package main

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

type interpreter struct {
	rip    int
	memory map[int]int
	Halt   bool
}

func main() {
	var program = loadProgram()

	for noun := 0; noun < 100; noun++ {
		for verb := 0; verb < 100; verb++ {
			vm := program.clone()
			vm.store(1, noun)
			vm.store(2, verb)
			for c := 0; c < 1000000 && !vm.Halt; c++ {
				vm.step()
			}
			if vm.load(0) == 19690720 {
				panic(fmt.Sprintf("100 * %d + %d = %d", noun, verb, 100*noun+verb))
			}
		}
	}

}

func loadProgram() interpreter {
	var machine interpreter
	machine.memory = make(map[int]int, 4096)
	buf := bytes.NewBuffer(nil)
	io.Copy(buf, os.Stdin)
	for i, v := range strings.Split(string(buf.Bytes()), ",") {
		x, err := strconv.Atoi(strings.TrimSpace(v))
		if err != nil {
			panic(err)
		}
		machine.store(i, x)
	}
	return machine
}

func (machine *interpreter) step() {
	opcode := machine.load(machine.rip)
	a := machine.lea(machine.rip + 1)
	b := machine.lea(machine.rip + 2)
	c := machine.load(machine.rip + 3)
	switch opcode {
	case 1:
		machine.store(c, a+b)
		machine.rip += 4
	case 2:
		machine.store(c, a*b)
		machine.rip += 4
	case 99:
		machine.Halt = true
	default:
		machine.Halt = true
		panic(fmt.Sprintf("Illegal Instruction %d", opcode))
	}
}

// Helpers

func (machine *interpreter) lea(address int) int {
	return machine.load(machine.load(address))
}

func (machine *interpreter) load(address int) int {
	val, ok := machine.memory[address]
	if !ok {
		val = 0
	}
	return val
}

func (machine *interpreter) store(address, value int) {
	machine.memory[address] = value
}

func (machine *interpreter) clone() interpreter {
	var other interpreter
	other.rip = machine.rip
	other.memory = make(map[int]int, len(machine.memory))
	for k, v := range machine.memory {
		other.memory[k] = v
	}
	return other
}
