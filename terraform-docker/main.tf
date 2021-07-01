terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "null_resource" "noderedvol" {
  provisioner "local-exec" {
  command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol"
  }
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}


resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }
  volumes {
    container_path = "/data"
    host_path = "/home/ubuntu/environment/terraform-docker/noderedvol"
  }
}










# resource "docker_container" "nodered_container2" {
#   name  = join("-", ["nodered", random_string.random2.result])
#   image = docker_image.nodered_image.latest
#   ports {
#     internal = 1880
#     #  external = 1880
#   }
# }


# output "ip_address1" {
#   value       = join(":", [docker_container.nodered_container[0].ip_address, docker_container.nodered_container[0].ports[0].external])
#   description = "The IP address and external port of the docker container"
# }

# output "ip_address1" {
#   value       = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address],i.ports[*]["external"])]
#   description = "The IP address and external port of the docker container"
# }

# output "container_name" {
#   value       = docker_container.nodered_container[*].name
#   description = "The name of the container"
# }

# output "ip_address2" {
#   value       = join(":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].external])
#   description = "This is the IP address and port number of the second container"
# }

# output "container2_name" {
#   value       = docker_container.nodered_container[1].name
#   description = "This is the name of the second container"
# }



