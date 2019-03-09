workflow "Build on Push" {
  on = "push"
  resolves = ["Build", "Test"]
}

action "Lint" {
  uses = "actions/action-builder/shell@master"
  runs = "make"
  args = "lint"
}

action "Test" {
  # TODO: Add back "Test Go Dep Vendor" once we resolve issue with `dep check` reporting invalid hash: https://github.com/cedrickring/golang-action/issues/8
  needs = ["Build", "Test Go Standard", "Test Go Modules", "Test Go Modules Vendor", "Test Go Dep"]
  uses = "actions/action-builder/shell@master"
  runs = "make"
  args = "test"
}

action "Test Go Standard" {
  needs = ["Build"]
  uses = "./"
  env = {
    PROJECT_PATH = "./tests/projects/go_standard"
    IMPORT = "cedrickring/golang-action"
  }
}

action "Test Go Modules" {
  needs = ["Build"]
  uses = "./"
  env = {
    PROJECT_PATH = "./tests/projects/go_modules"
    IMPORT = "cedrickring/golang-action"
  }
}

action "Test Go Modules Vendor" {
  needs = ["Build"]
  uses = "./"
  env = {
    PROJECT_PATH = "./tests/projects/go_modules_vendored"
    IMPORT = "cedrickring/golang-action"
  }
}

action "Test Go Dep" {
  needs = ["Build"]
  uses = "./"
  env = {
    PROJECT_PATH = "./tests/projects/go_dep"
    IMPORT = "cedrickring/golang-action"
  }
}

action "Test Go Dep Vendor" {
  needs = ["Build"]
  uses = "./"
  env = {
    PROJECT_PATH = "./tests/projects/go_dep_vendored"
    IMPORT = "cedrickring/golang-action"
  }
}

action "Build" {
  needs = ["Lint"]
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
  needs = ["Build", "Test", "Docker Login", "Docker Tag"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "publish"
}

action "Docker Tag" {
  needs = ["Build", "Test", "Docker Login"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "docker-tag"
}
