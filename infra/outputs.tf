output "function_endpoint" {
  value = "https://asia-east2-${var.project_id}.cloudfunctions.net/${local.function_name}"
}
