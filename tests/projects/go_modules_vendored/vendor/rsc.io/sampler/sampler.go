// Copyright 2018 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package sampler shows simple texts.
package sampler // import "rsc.io/sampler"

import (
	"os"
	"strings"

	"golang.org/x/text/language"
)

// DefaultUserPrefs returns the default user language preferences.
// It consults the $LC_ALL, $LC_MESSAGES, and $LANG environment
// variables, in that order.
func DefaultUserPrefs() []language.Tag {
	var prefs []language.Tag
	for _, k := range []string{"LC_ALL", "LC_MESSAGES", "LANG"} {
		if env := os.Getenv(k); env != "" {
			prefs = append(prefs, language.Make(env))
		}
	}
	return prefs
}

// Hello returns a localized greeting.
// If no prefs are given, Hello uses DefaultUserPrefs.
func Hello(prefs ...language.Tag) string {
	if len(prefs) == 0 {
		prefs = DefaultUserPrefs()
	}
	return hello.find(prefs)
}

func Glass() string {
	return "I can eat glass and it doesn't hurt me."
}

// A text is a localized text.
type text struct {
	byTag   map[string]string
	matcher language.Matcher
}

// newText creates a new localized text, given a list of translations.
func newText(s string) *text {
	t := &text{
		byTag: make(map[string]string),
	}
	var tags []language.Tag
	for _, line := range strings.Split(s, "\n") {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		f := strings.Split(line, ": ")
		if len(f) != 3 {
			continue
		}
		tag := language.Make(f[1])
		tags = append(tags, tag)
		t.byTag[tag.String()] = f[2]
	}
	t.matcher = language.NewMatcher(tags)
	return t
}

// find finds the text to use for the given language tag preferences.
func (t *text) find(prefs []language.Tag) string {
	tag, _, _ := t.matcher.Match(prefs...)
	s := t.byTag[tag.String()]
	if strings.HasPrefix(s, "RTL ") {
		s = "\u200F" + strings.TrimPrefix(s, "RTL ") + "\u200E"
	}
	return s
}
