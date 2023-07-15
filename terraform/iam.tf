resource "google_service_account" "cloud_run_invoker" {
  account_id   = "python-scraper-cr-invoker"
  display_name = "Service Account for ${var.cloud-run-job-name} Cloud Run invoker"
}

resource "google_project_iam_member" "cloud_run_invoker" {
  project = var.project
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.cloud_run_invoker.email}"
}

resource "google_service_account" "cloud_run_runtime" {
  account_id   = "python-scraper-cr-runtime"
  display_name = "Service Account for ${var.cloud-run-job-name} Cloud Run runtime"
}

resource "google_project_iam_member" "cloud_run_runtime" {
  project = var.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloud_run_runtime.email}"
  condition {
    title       = "resource_name_equals_client_assets"
    description = "Resource name equals client assets storage bucket"
    expression  = "resource.name == '${google_storage_bucket.assets.name}'"
  }
}