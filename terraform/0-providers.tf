terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.22.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }

    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.9.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "kind" {
}

provider "kubernetes" {
  config_path = pathexpand(var.kind_cluster_config_path)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kind_cluster_config_path)
  }
}
