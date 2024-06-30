package main

import (
	"fmt"
	"os"
)

func main() {
	if len(os.Args) <= 1 {
		os.Exit(1)
	}
	switch os.Args[1] {
	case "env":
		for i := 2; i < len(os.Args); i++ {
			fmt.Printf("%s=%q\n", os.Args[i], os.Getenv(os.Args[i]))
		}
	default:
		fmt.Printf("%q\n", os.Args[1:])
	}
}
