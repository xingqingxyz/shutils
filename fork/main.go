package main

import (
	"errors"
	"os"
	"os/exec"
)

var execPath string

func main() {
	cmd := exec.Command(execPath, os.Args[1:]...)
	cmd.Stdin = os.Stdin
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout
	err := cmd.Run()
	if errors.Is(err, &exec.ExitError{}) {
		panic(err)
	}
	os.Exit(cmd.ProcessState.ExitCode())
}
