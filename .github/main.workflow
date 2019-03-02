workflow "Build and Publish" {
  on = "push"
  resolves = "Docker Publish"
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
  uses = "actions/docker/cli@master"
  args = "build -t golang-action ."
}

action "Publish Filter" {
  needs = ["Build"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Docker Login" {
  needs = ["Publish Filter"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Publish" {
  needs = ["Publish Filter", "Build", "Docker Login", "Docker Tag"]
  uses = "actions/docker/cli@master"
  args = "push cedrickring/golang-action"
}

action "Docker Tag" {
  needs = ["Build", "Docker Login"]
  uses = "actions/docker/tag@master"
  args = "golang-action cedrickring/golang-action --no-latest"
}
