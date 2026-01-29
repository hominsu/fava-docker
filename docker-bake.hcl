target "metadata" {}

group "default" {
  targets = [
    "fava",
  ]
}

target "cross" {
  platforms = [
    "linux/arm64",
    "linux/amd64"
  ]
}

target "fava" {
  inherits = ["metadata", "cross"]
  context    = "."
  dockerfile = "fava/Dockerfile"
  args = {
    "FAVA_VERSION" = "${target.metadata.args.DOCKER_META_VERSION}"
  }
}
