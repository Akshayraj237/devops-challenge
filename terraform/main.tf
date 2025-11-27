terraform {
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes" }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "devops" {
  metadata { name = "devops-challenge" }
}

resource "kubernetes_resource_quota" "quota" {
  metadata {
    name      = "devops-quota"
    namespace = kubernetes_namespace.devops.metadata[0].name
  }
  spec {
    hard = {
      "requests.memory" = "512Mi"
      "limits.memory"   = "512Mi"
    }
  }
}

