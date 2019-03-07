package main_test

import (
	"testing"
)

func TestCmd(t *testing.T) {

	if "a" != "a" {
		t.Errorf("Expected a to == a")
	}
}
