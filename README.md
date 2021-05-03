[![](https://img.shields.io/github/release/cedrickring/golang-action.svg)](https://github.com/cedrickring/golang-action/releases/latest) [![Actions Status](https://github.com/cedrickring/golang-action/workflows/Build%20on%20Push/badge.svg)](https://github.com/cedrickring/golang-action/actions)

# Golang Action

This Action allows you to run Go commands with your code. It will automatically setup your workspace (`~/go/src/github.com/<your-name>/<repo>`) before the command is run.

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
      uses: cedrickring/golang-action@1.6.0
```


If no args are specified and a `Makefile` is detected, this action will run `make`. Otherwise `go test` and `go build` will be run.
To run a custom command, just use:
```yaml
steps:
- name: Run custom command
  uses: cedrickring/golang-action@1.6.0
  with:
    args: make my-target
```

If your repository's `import` name is different from the path on GitHub,
provide the `import` name by adding an environment variable
`IMPORT=import/name`.  This may be useful if you have forked an open
source Go project:
```yaml
steps:
- name: Run with custom import path
  uses: cedrickring/golang-action@1.6.0
  env:
    IMPORT: "root/repo"
```


To use Go Modules add `GO111MODULE=on` to the step:
```yaml
steps:
- name: Go Modules
  uses: cedrickring/golang-action@1.6.0
  env:
    GO111MODULE: "on"
```


If your go project is not located at the root of the repo you can also specify environment variable `PROJECT_PATH`:
```yaml
steps:
- name: Custom project path
  uses: cedrickring/golang-action@1.6.0
  env:
    PROJECT_PATH: "./path/in/my/project"
```

To use a specific golang version (1.10, 1.11, 1.12, 1.13, 1.14, 1.15), defaults to the latest version:
```yaml
steps:
- name: Use Go 1.11
  uses: cedrickring/golang-action/go1.11@1.6.0
```
