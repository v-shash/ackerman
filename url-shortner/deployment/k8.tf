
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  # token                  = data.aws_eks_cluster_auth.cluster.token
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
    command     = "aws"
  }
}



resource "kubernetes_deployment" "example" {
  metadata {
    name = "url-shortener-deployment"
    labels = {
      service = "UrlShortenerService"
    }
  }

  spec {
    replicas = var.pod_replicas

    selector {
      match_labels = {
        service = "UrlShortenerService"
      }
    }

    template {
      metadata {
        labels = {
          service = "UrlShortenerService"
        }
      }

      spec {
        container {
          image = "mhusseini/bitly"
          name  = "url-shortener"

          port {
            container_port = 8080
          }

          resources {
            limits = {
              cpu    = "1000m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "500m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = 8080
            }

            initial_delay_seconds = 15
            period_seconds        = 15

          }

          env {
            name  = "AWS_REGION"
            value = var.region
          }

          env {
            name  = "BASE_URL"
            value = format("http://%s", data.kubernetes_service.load_balancer_data.status[0].load_balancer[0].ingress[0].hostname)
          }

          env {
            name  = "AWS_SECRET_ACCESS_KEY"
            value = aws_iam_access_key.pod.secret
          }

          env {
            name  = "AWS_ACCESS_KEY_ID"
            value = aws_iam_access_key.pod.id
          }

          env {
            name  = "DB_TABLE_NAME"
            value = "UrlTable-MoHusseini"
          }

        }
      }
    }
  }

  depends_on = [kubernetes_service.load_balancer, aws_iam_user_policy.pod, module.dynamodb_table]
}

resource "kubernetes_service" "load_balancer" {
  metadata {
    name = "load-balancer"
  }

  spec {

    selector = {
      service = "UrlShortenerService"
    }

    port {
      port        = 80
      target_port = 8080
      protocol    = "TCP"
    }
    type = "LoadBalancer"
  }

  depends_on = [module.eks]
}


data "kubernetes_service" "load_balancer_data" {
  metadata {
    name = "load-balancer"
  }

  depends_on = [kubernetes_service.load_balancer]
}

# resource "kubernetes_ingress" "alb" {
#   wait_for_load_balancer = true
#   metadata {
#     name = "alb"
#     annotations = {
#       "kubernetes.io/ingress.class" = "alb"
#     }
#   }
#   spec {
#     rule {
#       http {
#         path {
#           path = "/*"
#           backend {
#             service_name = kubernetes_service.node_port.metadata.0.name
#             service_port = 80
#           }
#         }
#       }
#     }
#   }
# }


# data "kubernetes_ingress" "load_balancer" {
#   metadata {
#     name = "load-balancer"
#   }
# }
