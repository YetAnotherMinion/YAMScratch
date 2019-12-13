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
	ebp    int
	memory map[int]int
	Inputs []int
	Halt   bool
}

func main() {
	var vm = loadProgram()
	vm.Inputs = append(vm.Inputs, 2)

	for c := 0; c < 1000000 && !vm.Halt; c++ {
		vm.step()
	}
}

func loadProgram() interpreter {
	var machine interpreter
	machine.memory = make(map[int]int, 4096)
	machine.Inputs = make([]int, 0)
	buf := bytes.NewBuffer(nil)
	io.Copy(buf, os.Stdin)
	for i, v := range strings.Split(string(buf.Bytes()), ",") {
		x, err := strconv.Atoi(strings.TrimSpace(v))
		if err != nil {
			panic(err)
		}
		machine.store(0, i, x)
	}
	return machine
}

func (machine *interpreter) step() {
	opcode, ma, mb, mc := decode(machine.fetch(machine.rip))
	rax := machine.fetch(machine.rip + 1)
	rbx := machine.fetch(machine.rip + 2)
	rcx := machine.fetch(machine.rip + 3)
	switch opcode {
	case 1:
		rax = machine.load(ma, rax)
		rbx = machine.load(mb, rbx)
		machine.store(mc, rcx, rax+rbx)
		machine.rip += 4
	case 2:
		rax = machine.load(ma, rax)
		rbx = machine.load(mb, rbx)
		machine.store(mc, rcx, rax*rbx)
		machine.rip += 4
	case 3:
		debugAssert(ma != 1, "output parameters must not be in immediate mode")
		a := machine.Inputs
		if len(a) > 0 {
			tail := a[len(a)-1]
			machine.Inputs = a[:len(a)-1]
			machine.store(ma, rax, tail)
			machine.rip += 2
		}
	case 4:
		fmt.Println("output", machine.load(ma, rax))
		machine.rip += 2
	case 5:
		rax := machine.load(ma, rax)
		rbx := machine.load(mb, rbx)
		if rax != 0 {
			machine.rip = rbx
		} else {
			machine.rip += 3
		}
	case 6:
		rax := machine.load(ma, rax)
		rbx := machine.load(mb, rbx)
		if rax == 0 {
			machine.rip = rbx
		} else {
			machine.rip += 3
		}
	case 7:
		rax := machine.load(ma, rax)
		rbx := machine.load(mb, rbx)
		if rax < rbx {
			machine.store(mc, rcx, 1)
		} else {
			machine.store(mc, rcx, 0)
		}
		machine.rip += 4
	case 8:
		rax := machine.load(ma, rax)
		rbx := machine.load(mb, rbx)
		if rax == rbx {
			machine.store(mc, rcx, 1)
		} else {
			machine.store(mc, rcx, 0)
		}
		machine.rip += 4
	case 9:
		rax := machine.load(ma, rax)
		machine.ebp += rax
		machine.rip += 2
	case 99:
		machine.Halt = true
	default:
		machine.Halt = true
		panic(fmt.Sprintf("Illegal Instruction %d", opcode))
	}
}

// Helpers

func decode(instruction int) (opcode, ma, mb, mc int) {
	opcode = instruction % 100
	instruction /= 100
	ma = instruction % 10
	instruction /= 10
	mb = instruction % 10
	instruction /= 10
	mc = instruction % 10
	return
}

func (machine *interpreter) load(mode, address int) int {
	switch mode {
	case 0:
		return machine.fetch(address)
	case 1:
		return address
	case 2:
		return machine.fetch(address + machine.ebp)
	default:
		panic(fmt.Sprintf("Illegal load model: %d", mode))
	}
	return 0
}

func (machine *interpreter) fetch(address int) int {
	val, ok := machine.memory[address]
	if !ok {
		val = 0
	}
	return val
}

func (machine *interpreter) store(mode, address, value int) {
	switch mode {
	case 0:
		machine.memory[address] = value
	case 2:
		machine.memory[machine.ebp+address] = value
	default:
		panic(fmt.Sprintf("Illegal mode: %d", mode))
	}
}

func (machine *interpreter) clone() interpreter {
	var other interpreter
	other.rip = machine.rip
	other.memory = make(map[int]int, len(machine.memory))
	for k, v := range machine.memory {
		other.memory[k] = v
	}
	other.Inputs = make([]int, len(machine.Inputs))
	for i, v := range machine.Inputs {
		other.Inputs[i] = v
	}
	return other
}

func debugAssert(predicate bool, message string) {
	if !predicate {
		panic(message)
	}
}
