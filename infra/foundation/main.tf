terraform {
  required_version = "0.12.24"

  required_providers {
    google = "3.14.0"
  }
}

provider "google" {
  access_token = var.access_token
  project = var.project_id
  region = var.region
}

resource "google_project_service" "api_cloudkms" {
  service = "cloudkms.googleapis.com"
  disable_dependent_services = true
}

resource "google_kms_key_ring" "my_key_ring" {
  project  = var.project_id
  name     = var.kms_key_ring
  location = var.region
}

resource "google_kms_crypto_key" "my_crypto_key" {
  name     = var.kms_key_name
  key_ring = google_kms_key_ring.my_key_ring.self_link
}
