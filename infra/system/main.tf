terraform {
  required_version = "0.12.24"

  required_providers {
    google = "3.14.0"
    google-beta = "3.14.0"
    null = "2.1.2"
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

provider "google-beta" {
  access_token = var.access_token
  project = var.project_id
  region = var.region
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

resource "google_project_service" "api_dialogflow" {
  provider = google-beta

  service = "dialogflow.googleapis.com"
  disable_dependent_services = true
}

resource "google_storage_bucket" "bucket" {
  name = "my-foo-test-bucket"
}

resource "google_storage_bucket_object" "archive" {
  name   = "__function.zip"
  bucket = google_storage_bucket.bucket.name
  source = var.packaged_function_path
}

resource "google_service_account" "service_account" {
  account_id   = "dialogflow-webhook"
  display_name = "Dialogflow Webhook"
}

// // Cannot create this because of the issue introduced in 2.13
// // https://github.com/terraform-providers/terraform-provider-google/issues/4276
//resource "google_project_iam_member" "kms_key_user" {
//  role    = "roles/cloudkms.cryptoKeyDecrypter"
//  member  = "serviceAccount:${google_service_account.service_account.email}"
//}
resource "null_resource" "grant_kmd_decrypt_role" {
  triggers = {
    service_account_email = google_service_account.service_account.email
  }

  provisioner "local-exec" {
    command = <<-EOF
      gcloud projects add-iam-policy-binding "${var.project_id}" \
        --member "serviceAccount:${google_service_account.service_account.email}" \
        --role roles/cloudkms.cryptoKeyDecrypter
    EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOF
      gcloud projects remove-iam-policy-binding "${var.project_id}" \
        --member "serviceAccount:${google_service_account.service_account.email}" \
        --role roles/cloudkms.cryptoKeyDecrypter
    EOF
  }
}

resource "google_cloudfunctions_function" "function" {
  provider = google.hong_kong

  name        = local.function_name
  runtime     = "nodejs10"

  service_account_email = google_service_account.service_account.email
  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  timeout               = 10
  entry_point           = "handler"
  environment_variables = {
    ENCRYPTED_AUTH_KEY = var.encrypted_webhook_auth_key
    KMS_KEY_RING = var.kms_key_ring
    KMS_KEY_NAME = var.kms_key_name
    KMS_KEY_REGION = var.region
    KMS_KEY_PROJECT = var.project_id
    PEOPLE_SHEET_ID = var.people_sheet_id
    PEOPLE_SHEET_RANGE = var.people_sheet_range
  }
}

# IAM entry for a single user to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
