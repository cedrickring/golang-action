
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
  uses = "actions/docker/cli@master"
  args = "push cedrickring/golang-action"
}

action "Docker Tag" {
  needs = ["Build", "Docker Login"]
  uses = "actions/docker/tag@master"
  args = "golang-action cedrickring/golang-action --no-latest"
}
