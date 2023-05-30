resource "google_service_account" "cloud_run_invoker" {
  account_id   = "python-scraper-cr-invoker"
  display_name = "Service Account for ${var.cloud-run-job-name} Cloud Run invoker"
}

resource "google_project_iam_member" "cloud_run_invoker" {
  project = var.project
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.cloud_run_invoker.email}"
}