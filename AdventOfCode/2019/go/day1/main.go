package main

import (
    "fmt"
    "io"
)

func main() {
    var fuelRequired int
    for {
        var mass int
        n, err := fmt.Scanf("%d", &mass)
        if err != nil {
            if err == io.EOF {
                break
            }
            panic(err)
        }
        if n != 1 {
            panic("Expected a single int")
        }
        for {
            mass = (mass / 3) - 2
            if mass <= 0 {
                break
            }
            fuelRequired += mass
        }
    }
    fmt.Println(fuelRequired)
}
