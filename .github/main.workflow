workflow "Build on Push" {
  on = "push"
  resolves = "Build"
}

action "Lint" {
  uses = "actions/action-builder/shell@master"
  runs = "make"
  args = "lint"
}

action "Test" {
  uses = "actions/action-builder/shell@master"
  runs = "make"
  args = "test"
}

action "Build" {
  needs = ["Lint", "Test"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "build"
}

workflow "Build and Publish" {
  on = "release"
  resolves = "Docker Publish"
}

action "Docker Login" {
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Publish" {
  needs = ["Build", "Docker Login", "Docker Tag"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "publish"
}

action "Docker Tag" {
  needs = ["Build", "Docker Login"]
  uses = "actions/docker/tag@master"
  args = "golang-action cedrickring/golang-action --no-latest"
}
