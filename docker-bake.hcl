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
  dockerfile = "Dockerfile"
}
