terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
    }
    helm = {
      source = "hashicorp/helm"
    }
    kubectl = {
      source = "hashicorp/kubectl"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {

}

resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  ports {
    internal = 80
    external = 8000
  }
}
