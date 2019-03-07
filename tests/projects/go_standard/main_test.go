package main

import (
	"testing"
)

func TestCmd(t *testing.T) {

	if HelloMsg != "Hello Github Actions" {
		t.Errorf("main message expected to be [%s] but was [%s]", "Hello Github Actions", HelloMsg)
	}
}
