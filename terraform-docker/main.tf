terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container" {
  name  = "nodered"
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    external = 1880
  }
}

output "ip_address" {
  value       = docker_container.nodered_container.ip_address
  description = "The IP address of the docker container"
}

output "container_name" {
  value       = docker_container.nodered_container.name
  description = "The name of the container"
}

