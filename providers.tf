terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.35.0"
    }
  }
  required_version = "~> 1.2.8"
}