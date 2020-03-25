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

provider "google" {
  alias = "hong_kong"
  access_token = var.access_token
  project = var.project_id
  region = "asia-east2"
}

locals {
  function_name = "my-function"
}

resource "google_project_service" "api_cloudfunctions" {
  service = "cloudfunctions.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "api_sheets" {
  service = "sheets.googleapis.com"
  disable_dependent_services = true
}

resource "google_storage_bucket" "bucket" {
  name = "my-foo-test-bucket"
}

resource "google_storage_bucket_object" "archive" {
  name   = "__function.zip"
  bucket = google_storage_bucket.bucket.name
  source = "../__function.zip"
}

resource "google_service_account" "service_account" {
  account_id   = "dialogflow-webhook"
  display_name = "Dialogflow Webhook"
}

// // Cannot create this because of the issue introduced in 2.13
// // https://github.com/terraform-providers/terraform-provider-google/issues/4276
//resource "google_project_iam_member" "project" {
//  role    = "roles/viewer"
//  member  = "serviceAccount:${google_service_account.service_account.email}"
//}

resource "google_cloudfunctions_function" "function" {
  provider = google.hong_kong

  name        = local.function_name
  runtime     = "nodejs10"

  service_account_email = google_service_account.service_account.email
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  timeout               = 10
  entry_point           = "handler"
}

# IAM entry for a single user to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
