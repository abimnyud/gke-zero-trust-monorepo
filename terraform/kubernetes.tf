resource "kubernetes_deployment" "swagger_testing_1" {
  metadata {
    name = "swagger-testing-1-deployment"
    labels = {
      component = "swagger-testing-1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        component = "swagger-testing-1"
      }
    }

    template {
      metadata {
        labels = {
          component = "swagger-testing-1"
        }
      }

      spec {
        container {
          image = var.swagger_testing_1_image
          name  = "swagger-testing-1"

          port {
            container_port = 3000
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "swagger_testing_1" {
  metadata {
    name = "swagger-testing-1-service"
  }
  spec {
    selector = {
      component = "swagger-testing-1"
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "swagger_testing_2" {
  metadata {
    name = "swagger-testing-2-deployment"
    labels = {
      component = "swagger-testing-2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        component = "swagger-testing-2"
      }
    }

    template {
      metadata {
        labels = {
          component = "swagger-testing-2"
        }
      }

      spec {
        container {
          image = var.swagger_testing_2_image
          name  = "swagger-testing-2"

          port {
            container_port = 3001
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "swagger_testing_2" {
  metadata {
    name = "swagger-testing-2-service"
  }
  spec {
    selector = {
      component = "swagger-testing-2"
    }
    port {
      port        = 3000
      target_port = 3001
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "ingress_service" {
  metadata {
    name = "ingress-service"
    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = "web-static-ip"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/swagger-testing-1/*"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service.swagger_testing_1.metadata[0].name
              port {
                number = 3000
              }
            }
          }
        }
        path {
          path      = "/swagger-testing-2/*"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service.swagger_testing_2.metadata[0].name
              port {
                number = 3000
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "cloudflared" {
  metadata {
    name = "cloudflared-deployment"
    labels = {
      app = "cloudflared"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        pod = "cloudflared"
      }
    }

    template {
      metadata {
        labels = {
          pod = "cloudflared"
        }
      }

      spec {
        container {
          image   = "cloudflare/cloudflared:latest"
          name    = "cloudflared"
          command = ["cloudflared", "tunnel", "--metrics", "0.0.0.0:2000", "run"]
          args    = ["--token", var.cloudflare_token]

          liveness_probe {
            http_get {
              path = "/ready"
              port = 2000
            }
            failure_threshold     = 1
            initial_delay_seconds = 10
            period_seconds        = 10
          }
        }
      }
    }
  }
}
