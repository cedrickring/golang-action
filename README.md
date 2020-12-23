[![](https://img.shields.io/github/release/ce1rickring/golang-action.svg)](https://github.com/cedrickring/golang-action/releases/latest) [![Actions Status](https://github.com/cedrickring/golang-action/workflows/Build%20on%20Push/badge.svg)](https://github.com/cedrickring/golang-action/actions)

# Golang Action

This Action allows you to run Go commands with your code. It will automatically setup your workspace (`~/go/src/github.com/<your-name>/<repo>`) before the command is run.

**NOTE**: As of `v2.0.0` the `dep` support will be dropped for go versions greater than `1.14.x`.

## How to use

Create a `workflow.yaml` file in `.github/workflows` with the following contents:
```yaml
on: push
name: My cool Action
jobs:
  checks:
    name: run
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master

    - name: run
      uses: cedrickring/golang-action@v2.0.0
```


If no args are specified and a `Makefile` is detected, this action will run `make`. Otherwise `go test` and `go build` will be run.
To run a custom command, use:
```yaml
steps:
- name: Run custom command
  uses: cedrickring/golang-action@v2.0.0
  with:
    args: make my-target
```

If your go project is not located at the root of the repo you can also specify environment variable `PROJECT_PATH`:
```yaml
steps:
- name: Custom project path
  uses: cedrickring/golang-action@v2.0.0
  env:
    PROJECT_PATH: "./path/in/my/project"
```

To use a specific golang version (1.14, 1.15), defaults to the latest version:
```yaml
steps:
- name: Use Go 1.14
  uses: cedrickring/golang-action/go1.14@v2.0.0
```
