# Golang Action

This Action allows you to run Go commands with your code. It will automatically setup your workspace (`~/go/src/github.com/<your-name>/<repo>`) before the command is run.

## How to use

1. Add an Action
2. Enter "cedrickring/golang-action@1.1.0"
3. If your repo builds with `make` or `go build && go test`, that's all you need.  Otherwise, add a command in the args section like:
    ```bash
    go build -o my_executable main.go
    ```
    or run your `make` targets with
    ```bash
    make test
    ```

If your repository's `import` name is different from the path on GitHub,
provide the `import` name by adding an environment variable
`IMPORT=import/name`.  This may be useful if you have forked an open
source Go project.

If you prefer editing your `main.workflow` files by hand, use an `action`
block like this:

```hcl
action "ci" {
  uses="cedrickring/golang-action@1.1.0"

  # optional build command:
  args="./build.sh"

  # optional import name:
  env={
    IMPORT="root/repo"
  }
}
```
