terraform {
  required_version = ">= 0.12.6"

  required_providers {
    aws     = ">= 2.58"
    random  = ">= 2.0"
    kubernetes = "~> 2.0.2"
  }
}
